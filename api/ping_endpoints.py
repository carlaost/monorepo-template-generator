#!/usr/bin/env python3
"""
Intelligent API Endpoint Ping Script
Automatically discovers and tests all FastAPI endpoints
"""

import asyncio
import json
import sys
from datetime import datetime
from typing import Any, Dict, List, Optional

import httpx
import structlog
from rich import box
from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from rich.tree import Tree

# Import the FastAPI app to introspect routes
try:
    from app.main import app
except ImportError:
    print(
        "❌ Error: Could not import FastAPI app. Make sure you're in the api directory."
    )
    sys.exit(1)

console = Console()
logger = structlog.get_logger(__name__)


class EndpointTester:
    """Automatically discovers and tests FastAPI endpoints."""

    def __init__(self, base_url: str = "http://localhost:8000"):
        self.base_url = base_url
        self.client = httpx.AsyncClient(timeout=10.0)

    async def discover_endpoints(self) -> List[Dict[str, Any]]:
        """Discover all endpoints from the FastAPI app."""
        endpoints = []

        for route in app.routes:
            if hasattr(route, "methods") and hasattr(route, "path"):
                # Skip HEAD and OPTIONS methods for cleaner output
                methods = [m for m in route.methods if m not in ["HEAD", "OPTIONS"]]
                if methods:
                    endpoints.append(
                        {
                            "path": route.path,
                            "methods": methods,
                            "name": getattr(route, "name", "unknown"),
                            "tags": getattr(route, "tags", []),
                        }
                    )

        return sorted(endpoints, key=lambda x: x["path"])

    async def test_endpoint(
        self, endpoint: Dict[str, Any], method: str
    ) -> Dict[str, Any]:
        """Test a specific endpoint with a given method."""
        url = f"{self.base_url}{endpoint['path']}"
        start_time = datetime.now()

        try:
            if method == "GET":
                response = await self.client.get(url)
            elif method == "POST":
                # For POST endpoints, try with empty JSON body
                response = await self.client.post(url, json={})
            elif method == "PUT":
                response = await self.client.put(url, json={})
            elif method == "DELETE":
                response = await self.client.delete(url)
            else:
                return {
                    "status": "SKIPPED",
                    "reason": f"Method {method} not supported by tester",
                    "response_time": 0,
                }

            response_time = (datetime.now() - start_time).total_seconds() * 1000

            # Try to parse JSON response
            try:
                response_data = response.json()
            except:
                response_data = (
                    response.text[:100] + "..."
                    if len(response.text) > 100
                    else response.text
                )

            return {
                "status": "SUCCESS" if 200 <= response.status_code < 300 else "ERROR",
                "status_code": response.status_code,
                "response_time": round(response_time, 2),
                "response_data": response_data,
                "headers": dict(response.headers),
            }

        except Exception as e:
            response_time = (datetime.now() - start_time).total_seconds() * 1000
            return {
                "status": "FAILED",
                "error": str(e),
                "response_time": round(response_time, 2),
            }

    async def test_all_endpoints(self) -> Dict[str, Any]:
        """Test all discovered endpoints."""
        console.print("🔍 Discovering API endpoints...", style="blue")
        endpoints = await self.discover_endpoints()

        if not endpoints:
            console.print("❌ No endpoints discovered!", style="red")
            return {
                "endpoints": [],
                "summary": {"total": 0, "success": 0, "error": 0, "failed": 0},
            }

        console.print(f"📡 Found {len(endpoints)} endpoints", style="green")
        console.print()

        results = []
        summary = {"total": 0, "success": 0, "error": 0, "failed": 0, "skipped": 0}

        for endpoint in endpoints:
            for method in endpoint["methods"]:
                console.print(f"🔄 Testing {method} {endpoint['path']}", style="yellow")

                result = await self.test_endpoint(endpoint, method)
                result.update(
                    {
                        "endpoint": endpoint["path"],
                        "method": method,
                        "name": endpoint["name"],
                        "tags": endpoint["tags"],
                    }
                )

                results.append(result)
                summary["total"] += 1
                summary[result["status"].lower()] += 1

                # Print immediate result
                if result["status"] == "SUCCESS":
                    console.print(
                        f"  ✅ {result['status_code']} ({result['response_time']}ms)",
                        style="green",
                    )
                elif result["status"] == "ERROR":
                    console.print(
                        f"  ❌ {result['status_code']} ({result['response_time']}ms)",
                        style="red",
                    )
                elif result["status"] == "FAILED":
                    console.print(f"  💥 {result['error']}", style="red")
                else:
                    console.print(
                        f"  ⏩ {result.get('reason', 'Skipped')}", style="dim"
                    )

        await self.client.aclose()
        return {"endpoints": results, "summary": summary}

    def display_results_table(self, results: Dict[str, Any]):
        """Display results in a formatted table."""
        console.print("\n" + "=" * 80)
        console.print(
            "📊 API ENDPOINT TEST RESULTS", style="bold blue", justify="center"
        )
        console.print("=" * 80)

        table = Table(box=box.ROUNDED)
        table.add_column("Method", style="cyan", width=8)
        table.add_column("Endpoint", style="yellow", width=30)
        table.add_column("Status", width=10)
        table.add_column("Code", width=6)
        table.add_column("Time (ms)", width=10)
        table.add_column("Response Preview", width=20)

        for result in results["endpoints"]:
            # Status styling
            if result["status"] == "SUCCESS":
                status_style = "green"
                status_icon = "✅"
            elif result["status"] == "ERROR":
                status_style = "red"
                status_icon = "❌"
            elif result["status"] == "FAILED":
                status_style = "red"
                status_icon = "💥"
            else:
                status_style = "dim"
                status_icon = "⏩"

            # Response preview
            if "response_data" in result:
                if isinstance(result["response_data"], dict):
                    preview = json.dumps(result["response_data"])[:20] + "..."
                else:
                    preview = str(result["response_data"])[:20] + "..."
            else:
                preview = result.get("error", "N/A")[:20]

            table.add_row(
                result["method"],
                result["endpoint"],
                f"{status_icon} {result['status']}",
                str(result.get("status_code", "N/A")),
                str(result.get("response_time", "N/A")),
                preview,
            )

        console.print(table)

        # Summary
        summary = results["summary"]
        summary_table = Table(title="📈 Summary", box=box.DOUBLE_EDGE)
        summary_table.add_column("Metric", style="cyan")
        summary_table.add_column("Count", style="green")

        summary_table.add_row("Total Endpoints", str(summary["total"]))
        summary_table.add_row("✅ Successful", str(summary["success"]))
        summary_table.add_row("❌ Errors", str(summary["error"]))
        summary_table.add_row("💥 Failed", str(summary["failed"]))
        summary_table.add_row("⏩ Skipped", str(summary["skipped"]))

        success_rate = (
            (summary["success"] / summary["total"] * 100) if summary["total"] > 0 else 0
        )
        summary_table.add_row("Success Rate", f"{success_rate:.1f}%")

        console.print(summary_table)

    def display_route_tree(self, endpoints: List[Dict[str, Any]]):
        """Display endpoints as a tree structure."""
        tree = Tree("🌳 API Route Structure")

        # Group by first path segment
        path_groups = {}
        for endpoint in endpoints:
            path_parts = endpoint["path"].strip("/").split("/")
            root = path_parts[0] if path_parts[0] else "root"
            if root not in path_groups:
                path_groups[root] = []
            path_groups[root].append(endpoint)

        for group_name, group_endpoints in sorted(path_groups.items()):
            group_branch = tree.add(f"📁 /{group_name}")
            for endpoint in sorted(group_endpoints, key=lambda x: x["path"]):
                methods_str = ", ".join(endpoint["methods"])
                endpoint_branch = group_branch.add(
                    f"{endpoint['path']} [{methods_str}]"
                )
                if endpoint["tags"]:
                    endpoint_branch.add(f"🏷️  Tags: {', '.join(endpoint['tags'])}")

        console.print(tree)


async def main():
    """Main function to run the endpoint tests."""
    console.print(
        Panel.fit(
            "🚀 Oshima API Endpoint Tester\n"
            "Automatically discovers and tests all FastAPI endpoints",
            title="API Testing Tool",
            border_style="blue",
        )
    )

    # Check if API is running
    try:
        async with httpx.AsyncClient() as client:
            response = await client.get("http://localhost:8000/health")
            if response.status_code == 200:
                console.print("✅ API is running and healthy", style="green")
            else:
                console.print(
                    f"⚠️  API responded with status {response.status_code}",
                    style="yellow",
                )
    except Exception as e:
        console.print(f"❌ Cannot connect to API: {e}", style="red")
        console.print(
            "💡 Make sure the API is running on http://localhost:8000", style="blue"
        )
        return

    tester = EndpointTester()

    # Show route structure first
    endpoints = await tester.discover_endpoints()
    console.print()
    tester.display_route_tree(endpoints)
    console.print()

    # Run tests
    results = await tester.test_all_endpoints()

    # Display results
    tester.display_results_table(results)

    # Save results to file
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    results_file = f"api_test_results_{timestamp}.json"

    with open(results_file, "w") as f:
        json.dump(
            {
                "timestamp": datetime.now().isoformat(),
                "base_url": tester.base_url,
                "results": results,
            },
            f,
            indent=2,
        )

    console.print(f"\n💾 Results saved to: {results_file}", style="green")


if __name__ == "__main__":
    asyncio.run(main())

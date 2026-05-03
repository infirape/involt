import { jwtVerify } from "jose";
import type { NextRequest } from "next/server";
import { NextResponse } from "next/server";

const JWT_SECRET = new TextEncoder().encode(
  process.env.JWT_SECRET || "super-secret-key-change-me-in-prod",
);

export async function middleware(request: NextRequest) {
  const token = request.cookies.get("admin_token")?.value;
  const isLoginPage = request.nextUrl.pathname === "/login";

  if (!token) {
    if (isLoginPage) return NextResponse.next();
    return NextResponse.redirect(new URL("/login", request.url));
  }

  try {
    const { payload } = await jwtVerify(token, JWT_SECRET);

    // If user is logged in and tries to access login page, redirect to dashboard
    if (isLoginPage) {
      return NextResponse.redirect(new URL("/dashboard", request.url));
    }

    // Role-based access control (RBAC)
    const role = payload.role as string;
    const path = request.nextUrl.pathname;

    // Admin has access to everything.
    // Supervisor and Reader might have restrictions later.
    // Example: Only Admin can access /users
    if (path.startsWith("/users") && role !== "ADMIN") {
      return NextResponse.redirect(new URL("/dashboard", request.url));
    }

    return NextResponse.next();
  } catch (err) {
    console.error("JWT validation failed:", err);
    if (isLoginPage) return NextResponse.next();
    const response = NextResponse.redirect(new URL("/login", request.url));
    response.cookies.delete("admin_token");
    return response;
  }
}

export const config = {
  matcher: ["/dashboard/:path*", "/users/:path*", "/settings/:path*", "/login"],
};

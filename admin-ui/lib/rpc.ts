// lib/rpc.ts
import { createClient, type Interceptor } from "@connectrpc/connect";
import { createConnectTransport } from "@connectrpc/connect-web";
import { AdminService } from "@/app/gen/involt/v1/admin_pb";

const authInterceptor: Interceptor = (next) => async (req) => {
  const cookieRow = document.cookie
    .split("; ")
    .find((row) => row.startsWith("admin_token="));
  const token = cookieRow ? cookieRow.substring("admin_token=".length) : undefined;

  if (token) {
    req.header.set("Authorization", `Bearer ${token}`);
  }
  return await next(req);
};

const transport = createConnectTransport({
  baseUrl: process.env.NEXT_PUBLIC_API_URL || "http://localhost:8080",
  interceptors: [authInterceptor],
});

export const adminClient = createClient(AdminService, transport);

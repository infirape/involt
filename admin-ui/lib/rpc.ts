// lib/rpc.ts
import { createClient, type Interceptor } from "@connectrpc/connect";
import { createConnectTransport } from "@connectrpc/connect-web";
import { AdminService } from "@/app/gen/involt/v1/admin_pb";
import { SyncService } from "@/app/gen/involt/v1/sync_pb";

import { getAdminToken, API_BASE_URL } from "./utils";

const authInterceptor: Interceptor = (next) => async (req) => {
  const token = getAdminToken();

  if (token) {
    req.header.set("Authorization", `Bearer ${token}`);
  }
  return await next(req);
};

const transport = createConnectTransport({
  baseUrl: API_BASE_URL,
  interceptors: [authInterceptor],
});

export const adminClient = createClient(AdminService, transport);
export const syncClient = createClient(SyncService, transport);

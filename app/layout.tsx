import * as Sentry from "@sentry/nextjs";
import type { Metadata } from "next";
export function generateMetadata(): Metadata {
  return {
    // ... your existing metadata
    other: {
      ...Sentry.getTraceData(),
    },
  };
}

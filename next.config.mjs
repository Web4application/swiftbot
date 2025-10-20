import { withSentryConfig } from "@sentry/nextjs";
const nextConfig = {
  // Your existing Next.js configuration
};
// Make sure adding Sentry options is the last code to run before exporting
export default withSentryConfig(nextConfig, {
  org: "web4app",
  project: "swiftbot",
  // Only print logs for uploading source maps in CI
  // Set to `true` to suppress logs
  silent: !process.env.CI,
  // Automatically tree-shake Sentry logger statements to reduce bundle size
  disableLogger: true,
});

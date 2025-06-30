import * as Sentry from "@sentry/nextjs";
Sentry.init({
  dsn: "https://55038c1e414932ec8d81c34e5ef120fa@o4509364065402880.ingest.de.sentry.io/4509364112457808",
  // Adds request headers and IP for users, for more info visit:
  // https://docs.sentry.io/platforms/javascript/guides/nextjs/configuration/options/#sendDefaultPii
  sendDefaultPii: true,
  // ...
  // Note: if you want to override the automatic release value, do not set a
  // `release` value here - use the environment variable `SENTRY_RELEASE`, so
  // that it will also get attached to your source maps
});

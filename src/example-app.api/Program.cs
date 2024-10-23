using OpenTelemetry;
using OpenTelemetry.Trace;

var builder = WebApplication.CreateBuilder(args);

// Configure OpenTelemetry
builder.

var app = builder.Build();

app.MapGet("/", () => "Hello World!");

app.Run();

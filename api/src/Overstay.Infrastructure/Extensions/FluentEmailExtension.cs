using FluentEmail.Core;
using FluentEmail.Razor;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Overstay.Infrastructure.Extensions;

public static class FluentEmailExtensions
{
    public static void AddFluentEmail(
        this IServiceCollection services,
        ConfigurationManager configuration
    )
    {
        Email.DefaultRenderer = new RazorRenderer();

        var emailSettings = configuration.GetSection("EmailSettings");

        var defaultFromEmail = emailSettings["DefaultFromEmail"];
        var host = emailSettings["Host"];
        var port = emailSettings.GetValue<int>("Port");
        var userName = emailSettings["UserName"];
        var password = emailSettings["Password"];

        if (string.IsNullOrEmpty(userName) || string.IsNullOrEmpty(password))
        {
            services.AddFluentEmail(defaultFromEmail).AddSmtpSender(host, port).AddRazorRenderer();
            return;
        }

        services
            .AddFluentEmail(defaultFromEmail)
            .AddSmtpSender(host, port, userName, password)
            .AddRazorRenderer();
    }
}

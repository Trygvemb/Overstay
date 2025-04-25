using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Overstay.Infrastructure.Configurations;

public class NotificationConfigurations : IEntityTypeConfiguration<Notification>
{
    public void Configure(EntityTypeBuilder<Notification> builder)
    {
        builder.ToTable("Notifications");

        builder.HasKey(n => n.Id);
        builder
            .HasOne(n => n.User)
            .WithOne(u => u.Notification)
            .HasForeignKey<Notification>(n => n.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.Property(n => n.Id).ValueGeneratedOnAdd().HasColumnName("Id").IsRequired();
        builder.Property(n => n.CreatedAt).ValueGeneratedOnAdd().HasColumnName("CreatedAt");
        builder.Property(n => n.UpdatedAt).ValueGeneratedOnAddOrUpdate().HasColumnName("UpdatedAt");
        builder.Property(n => n.EmailNotification).HasColumnName("EmailNotification");
        builder.Property(n => n.PushNotification).HasColumnName("PushNotification");
        builder.Property(n => n.SmsNotification).HasColumnName("SmsNotification");
        builder.Property(n => n.UserId).HasColumnName("UserId").IsRequired();
    }
}

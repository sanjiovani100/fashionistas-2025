# Supabase Import Files

This directory contains SQL files split from the main schema.sql file for easier import into Supabase.

## Import Order

Import these files in the following order:

1. `01-extensions.sql` - Database extensions
2. `02-timestamp-function.sql` - Timestamp management function
3. `03-user-management.sql` - User management tables
4. `04-designers.sql` - Designers table
5. `05-event-categories.sql` - Event categories table
6. `06-venues.sql` - Venues table
7. `07-fashion-events.sql` - Fashion events table
8. `08-event-to-designer.sql` - Event to designer junction table
9. `09-ticket-types.sql` - Ticket types table
10. `10-orders.sql` - Orders table
11. `11-order-items.sql` - Order items table
12. `12-tickets.sql` - Tickets table
13. `13-sample-user-roles.sql` - Sample user roles data
14. `14-sample-designers.sql` - Sample designers data
15. `15-sample-event-categories.sql` - Sample event categories data
16. `16-sample-venues.sql` - Sample venues data
17. `17-sample-fashion-events.sql` - Sample fashion events data
18. `18-sample-event-to-designer.sql` - Sample event to designer connections
19. `19-sample-ticket-types.sql` - Sample ticket types data

## Import Instructions

1. Log in to your Supabase dashboard
2. Select your project
3. Navigate to the "SQL Editor" section
4. For each file:
   - Click "New Query"
   - Copy and paste the contents of the file
   - Run the query
   - Verify that it executed successfully before proceeding to the next file

## Troubleshooting

If you encounter errors:
- Check that you're importing the files in the correct order
- Verify that all previous imports completed successfully
- Check for any syntax errors or incompatibilities with your Supabase version

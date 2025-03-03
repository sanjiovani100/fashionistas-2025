/**
 * Export Schema Script
 * 
 * This script reads the schema.sql file and exports it in chunks that are easier
 * to copy and paste into the Supabase SQL Editor.
 * 
 * Usage: node export-schema.js
 */

const fs = require('fs');
const path = require('path');

// Path to the schema.sql file
const schemaPath = path.join(__dirname, '../../template-solar/src/lib/schema.sql');

// Output directory for the chunked SQL files
const outputDir = path.join(__dirname, 'supabase-import');

// Create output directory if it doesn't exist
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

// Read the schema file
const schema = fs.readFileSync(schemaPath, 'utf8');

// Split the schema into logical sections
const sections = [
  {
    name: '01-extensions',
    pattern: /-- Enable necessary extensions[\s\S]*?CREATE EXTENSION IF NOT EXISTS "pgcrypto";/,
    description: 'Database extensions'
  },
  {
    name: '02-timestamp-function',
    pattern: /-- ===============================\s*-- TIMESTAMP MANAGEMENT[\s\S]*?\$\$ LANGUAGE plpgsql;/,
    description: 'Timestamp management function'
  },
  {
    name: '03-user-management',
    pattern: /-- ===============================\s*-- 1\. USER MANAGEMENT[\s\S]*?PRIMARY KEY \(user_id, role_id\)\);/,
    description: 'User management tables'
  },
  {
    name: '04-designers',
    pattern: /-- ===============================\s*-- 2\. DESIGNERS[\s\S]*?EXECUTE FUNCTION trigger_set_timestamp\(\);/,
    description: 'Designers table'
  },
  {
    name: '05-event-categories',
    pattern: /-- Event Categories Table[\s\S]*?EXECUTE FUNCTION trigger_set_timestamp\(\);/,
    description: 'Event categories table'
  },
  {
    name: '06-venues',
    pattern: /-- Venues Table[\s\S]*?EXECUTE FUNCTION trigger_set_timestamp\(\);/,
    description: 'Venues table'
  },
  {
    name: '07-fashion-events',
    pattern: /-- Fashion Events Table[\s\S]*?EXECUTE FUNCTION trigger_set_timestamp\(\);/,
    description: 'Fashion events table'
  },
  {
    name: '08-event-to-designer',
    pattern: /-- Event to Designer Junction Table[\s\S]*?PRIMARY KEY \(event_id, designer_id\)\);/,
    description: 'Event to designer junction table'
  },
  {
    name: '09-ticket-types',
    pattern: /-- Ticket Types Table[\s\S]*?EXECUTE FUNCTION trigger_set_timestamp\(\);/,
    description: 'Ticket types table'
  },
  {
    name: '10-orders',
    pattern: /-- Orders Table[\s\S]*?EXECUTE FUNCTION trigger_set_timestamp\(\);/,
    description: 'Orders table'
  },
  {
    name: '11-order-items',
    pattern: /-- Order Items Table[\s\S]*?EXECUTE FUNCTION trigger_set_timestamp\(\);/,
    description: 'Order items table'
  },
  {
    name: '12-tickets',
    pattern: /-- Tickets Table[\s\S]*?EXECUTE FUNCTION trigger_set_timestamp\(\);/,
    description: 'Tickets table'
  },
  {
    name: '13-sample-user-roles',
    pattern: /-- Sample User Roles[\s\S]*?\('attendee', 'Regular user who can purchase tickets'\);/,
    description: 'Sample user roles data'
  },
  {
    name: '14-sample-designers',
    pattern: /-- Sample Designers[\s\S]*?'amara-okafor', TRUE\);/,
    description: 'Sample designers data'
  },
  {
    name: '15-sample-event-categories',
    pattern: /-- Sample Event Categories[\s\S]*?'all-season', 'sustainable'\);/,
    description: 'Sample event categories data'
  },
  {
    name: '16-sample-venues',
    pattern: /-- Sample Venues[\s\S]*?TRUE, TRUE, TRUE\);/,
    description: 'Sample venues data'
  },
  {
    name: '17-sample-fashion-events',
    pattern: /-- Sample Fashion Events[\s\S]*?TRUE, '\/images\/event-highlights\/vip.jpg'\);/,
    description: 'Sample fashion events data'
  },
  {
    name: '18-sample-event-to-designer',
    pattern: /-- Connect Events to Designers[\s\S]*?\(3, 3, FALSE, 2\);/,
    description: 'Sample event to designer connections'
  },
  {
    name: '19-sample-ticket-types',
    pattern: /-- Sample Ticket Types[\s\S]*?'Sustainable fashion toolkit'\], FALSE\);/,
    description: 'Sample ticket types data'
  }
];

// Extract and save each section
sections.forEach(section => {
  const match = schema.match(section.pattern);
  if (match) {
    const content = match[0];
    const filePath = path.join(outputDir, `${section.name}.sql`);
    fs.writeFileSync(filePath, content);
    console.log(`Exported ${section.name}: ${section.description}`);
  } else {
    console.error(`Section not found: ${section.name}`);
  }
});

// Create an index file with instructions
const indexContent = `# Supabase Import Files

This directory contains SQL files split from the main schema.sql file for easier import into Supabase.

## Import Order

Import these files in the following order:

${sections.map((section, index) => `${index + 1}. \`${section.name}.sql\` - ${section.description}`).join('\n')}

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
`;

fs.writeFileSync(path.join(outputDir, 'README.md'), indexContent);
console.log('Created README.md with import instructions');

console.log('\nExport complete! Files are in the supabase-import directory.'); 
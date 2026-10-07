# Smart Pass backend

Visitor management API for Konza Technology City (Node.js, Express, PostgreSQL).

## Setup

1. `npm install`
2. Create a database: `createdb smartpass`
3. Load the schema: `psql -d smartpass -f db/schema.sql`
4. Copy `.env.example` to `.env` and fill in your values
5. `npm run dev`

Check it works: http://localhost:5000/health

## Make yourself an admin

Register through the API first, then run:

    UPDATE users SET role = 'admin' WHERE email = 'you@example.com';

## Endpoints

| Method | Path | Access |
|---|---|---|
| POST | /api/auth/register | public |
| POST | /api/auth/login | public |
| GET | /api/auth/me | logged in |
| GET | /api/visit-types | public |
| POST | /api/visits | logged in |
| GET | /api/visits | logged in (own bookings) |
| PATCH | /api/visits/:id/cancel | logged in (own booking) |
| GET | /api/admin/visits?status=pending | admin |
| PATCH | /api/admin/visits/:id/approve | admin |
| PATCH | /api/admin/visits/:id/reject | admin |
| POST | /api/admin/check-in | admin |

Send the token as `Authorization: Bearer <token>`.
s
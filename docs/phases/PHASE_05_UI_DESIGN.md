# Phase 5 — UI Design System

## 5.1 Design Language

**Modern Government Software** — Material Design 3, Persian RTL, professional minimalism.

### Brand Direction
- Primary: Deep teal-blue `#0B3D4A` (gas/energy institutional, not purple)
- Secondary: Warm amber `#C45C26` (accent sparingly for CTAs)
- Surface light: `#F7F9FA` with subtle mesh gradient
- Surface dark: `#0E1A1F`
- Success / warning / error semantic tokens

### Typography
- Persian: **Vazirmatn** (primary)
- Numbers: tabular lining where possible
- Scale: Display 32 / Headline 24 / Title 18 / Body 15 / Label 13
- Large readable defaults for office monitors and tablets

### Layout
- Desktop: NavigationRail + content (≥900px)
- Tablet/Android: NavigationDrawer / BottomNav adaptive
- Cards: 12–16px radius, soft elevation 1–2, no clutter
- Dashboard: KPI row + charts + recent activity — one composition

### Motion
1. Login card fade+slide 280ms
2. Dashboard KPI count-up
3. Route shared-axis transition (Material)

### Dark / Light
Full M3 `ColorScheme.fromSeed` + custom overrides; user toggle in Settings; follow system optional.

### Components Catalog
- `GazAppBar`, `GazCard`, `GazDataTable`, `GazSearchField`
- `GazFormSection`, `GazEmptyState`, `GazConfirmDialog`
- `GazStatusChip`, `GazPermissionGate`, `GazChartCard`

### Screen Inventory
Login, Lock, Dashboard, Employee List, Employee Details (tabs), Document Manager, Report Builder, Search, Backup, Users & Roles, Audit Log, Settings — plus shared dialogs/tables/forms/charts.

## 5.2 Accessibility
- Contrast ≥ 4.5:1 body text
- Touch targets ≥ 48dp on Android
- Keyboard navigation on Windows

# PROJECT BRIEF - Ananda App

**Quick Start Guide untuk AI Developer**

---

## 🎯 TL;DR

Bangun aplikasi Android untuk monitoring tumbuh kembang anak usia 0-5 tahun.
- **Tech:** Flutter + SQLite
- **Mode:** 100% Offline
- **Target:** Orang tua & tenaga kesehatan
- **Style:** Glassmorphism + Teal/Cream gradient

---

## 📦 What You're Building

### Core Features (MVP v1.0.0)

**1. Materi Edukatif** 📚
- 3 kategori usia: 0-1, 1-2, 2-5 tahun
- Topik: Pertumbuhan, Perkembangan, Nutrisi, Stimulasi, Perawatan
- Format: Card-based (bukan tabel)
- Search + Bookmark

**2. Tools Skrining** ✅
- KPSP (16 rentang usia)
- Kalkulator Status Gizi
- TDD (Tes Daya Dengar)
- M-CHAT-R (Autisme)

**3. Profil Anak** 👶
- Multiple profiles
- Riwayat skrining
- Auto-fill umur
- Reminder jadwal

**4. UI Modern** 🎨
- Glassmorphism design
- Bottom navigation
- User-friendly untuk awam

---

## 📁 Files You Have

| File | Purpose |
|------|---------|
| `ARCHITECTURE.md` | **📖 BACA INI DULU!** Complete technical guide |
| `README.md` | Project overview & setup |
| `CHANGELOG.md` | Version tracking |
| `init_database.sql` | Database setup script |
| `legal_texts.dart` | Legal constants (ready to use) |
| `colors.dart` | Color constants (ready to use) |
| `app_info.dart` | App metadata constants |

---

## 🚀 Getting Started

### Step 1: Read Documentation (15 mins)
1. **START HERE:** Read `ARCHITECTURE.md` Section:
   - Project Structure
   - Database Schema
   - Design System
   - **DEVELOPER GUIDELINES** ⚠️ (CRITICAL!)

2. Skim `README.md` for context

### Step 2: Setup Project (10 mins)
```bash
flutter create ananda_app
cd ananda_app
```

### Step 3: Setup Structure (5 mins)
Create folder structure sesuai `ARCHITECTURE.md`:
```
lib/
├── screens/
├── widgets/
├── models/
├── services/
├── utils/constants/
├── utils/helpers/
└── data/json/
```

Copy files:
- `legal_texts.dart` → `lib/utils/constants/`
- `colors.dart` → `lib/utils/constants/`
- `app_info.dart` → `lib/utils/constants/`

### Step 4: Dependencies (5 mins)
Update `pubspec.yaml`:
```yaml
dependencies:
  provider: ^6.1.1
  sqflite: ^2.3.0
  path_provider: ^2.1.1
  flutter_local_notifications: ^16.3.0
  timezone: ^0.9.2
  intl: ^0.18.1
  shared_preferences: ^2.2.2
```

Run: `flutter pub get`

### Step 5: Start Building! 🔨

---

## 📋 Development Checklist

### Phase 1: Foundation
- [ ] Create `database_service.dart`
- [ ] Create models: `child_profile.dart`, `material.dart`, `screening_result.dart`
- [ ] Initialize database with `init_database.sql`
- [ ] Test database CRUD operations

### Phase 2: Core UI
- [ ] Create `main.dart` with routing
- [ ] Create `home_screen.dart`
- [ ] Create `glass_card.dart` widget
- [ ] Create `bottom_navigation.dart` widget
- [ ] Test navigation flow

### Phase 3: Materi Features
- [ ] Create `material_list_screen.dart`
- [ ] Create `material_detail_screen.dart`
- [ ] Implement search functionality
- [ ] Implement bookmark system
- [ ] Populate materials dari JSON

### Phase 4: Screening Features
- [ ] Create `kpsp_screen.dart`
- [ ] Create `calculator_screen.dart`
- [ ] Implement KPSP scoring logic
- [ ] Implement Gizi calculator
- [ ] Create `result_screen.dart`

### Phase 5: Profile Features
- [ ] Create `profile_list_screen.dart`
- [ ] Create `add_profile_screen.dart`
- [ ] Create `profile_detail_screen.dart`
- [ ] Create `history_screen.dart`
- [ ] Implement reminder scheduling

### Phase 6: Legal & Settings
- [ ] Create all settings screens
- [ ] Implement legal pages (use `legal_texts.dart`)
- [ ] Create onboarding flow
- [ ] Add help & tutorial

### Phase 7: Polish
- [ ] Error handling
- [ ] Loading states
- [ ] Empty states
- [ ] Input validation
- [ ] Testing

### Phase 8: Build
- [ ] App icon
- [ ] Splash screen
- [ ] Build signed APK
- [ ] Test installation

---

## ⚠️ CRITICAL RULES (from ARCHITECTURE.md)

### Rule 1: Use Artifacts
✅ Every code in artifact  
❌ No code in chat

### Rule 2: One File at a Time
✅ 1 file per response  
❌ No bulk file dumps

### Rule 3: Never Rewrite
✅ Edit existing code  
❌ Don't rewrite entire files

### Rule 4: Concise Instructions
✅ Max 3 lines  
❌ No long explanations

### Rule 5: Test Each Module
✅ Wait for approval  
❌ Don't skip testing

---

## 🎨 Design Quick Reference

### Colors (use from `colors.dart`)
```dart
AppColors.primary        // #26A69A (Teal)
AppColors.secondary      // #FFB74D (Orange)
AppColors.success        // #66BB6A (Green)
AppColors.warning        // #FFA726 (Orange)
AppColors.danger         // #EF5350 (Red)
```

### Glassmorphism Template
```dart
Container(
  decoration: BoxDecoration(
    color: AppColors.glassWhite,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.glassBorder, width: 1.5),
  ),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: YourContent(),
  ),
)
```

---

## 💬 Communication Template

Use this format for every response:

```markdown
## [Task Name]

**File:** lib/path/to/file.dart  
**Action:** Create/Edit  
**Dependencies:** [list if any]

[Artifact with code]

**Installation:**
1. Save to path above

**Testing:**
1. How to test this

**Next:** What's next
```

---

## 🆘 When You're Stuck

1. **STOP** - Don't guess
2. **EXPLAIN** - What's the issue
3. **ASK** - Request clarification
4. **WAIT** - For user approval

Never:
- Implement workarounds without asking
- Skip functionality
- Change architecture unilaterally

---

## 📊 Progress Tracking

Update at start/end of each session:

```
**Session Start:**
Phase: X - Module Y (Z%)
Last completed: [files]
Today's goal: [tasks]

**Session End:**
Completed: [files]
Tested: ✅/❌
Issues: [if any]
Next: [tasks]
```

---

## 🎯 Success Metrics

You're doing great if:
- ✅ Every file runs without errors
- ✅ User minimal revisions
- ✅ Code is clean & commented
- ✅ Following architecture strictly
- ✅ Efficient workflow (2-3 files/session max)

---

## 📞 Quick Reference Links

- **Main Guide:** `ARCHITECTURE.md`
- **Developer Rules:** `ARCHITECTURE.md#developer-guidelines`
- **Database Schema:** `init_database.sql`
- **Design System:** `ARCHITECTURE.md#design-system`
- **Legal Texts:** `legal_texts.dart`

---

## 🔑 Key Takeaways

1. **Read ARCHITECTURE.md first** - Everything is there
2. **One file at a time** - Quality over speed
3. **Test each module** - Don't skip
4. **Ask when unclear** - Better than guessing
5. **Follow design system** - Use constants

---

## 🚦 Ready to Start?

**Your first task:**
1. Read `ARCHITECTURE.md` (focus on Developer Guidelines)
2. Setup project structure
3. Create `database_service.dart`
4. Wait for user confirmation
5. Continue with checklist

**Remember:** Quality > Speed. Go slow and solid.

---

**Good luck! You got this!** 🚀

---

**Last Updated:** 2025-11-15  
**For questions:** Refer to ARCHITECTURE.md or ask user

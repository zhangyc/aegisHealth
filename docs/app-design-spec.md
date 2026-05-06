# LuluHealth App Design Spec

## 1. Product Definition

### 1.1 Core Statement

LuluHealth is a calorie-burn visualization app focused on human energy flow, not calorie bookkeeping.

The product explains one day of the body as:

- `energy in`: food intake
- `energy processing`: digestion cost
- `energy maintenance`: basal metabolism and thermal regulation
- `energy output`: movement and workouts
- `energy balance`: surplus or deficit

### 1.2 Product Goal

Help users lose weight by making calorie flow visible, understandable, and actionable.

### 1.3 Primary User Question

Users should be able to answer these questions within 5 seconds:

- How much energy have I taken in today?
- How much has my body burned already?
- Am I currently in deficit or surplus?
- What should I do next to hit today’s fat-loss target?

## 2. Design Principles

### 2.1 Visual Direction

- Apple-style health technology, not gym poster, not medical diagram, not fantasy fire effect
- Human silhouette should feel calm, premium, alive, and energetic
- The app should represent `thermal flow`, not `human body on fire`

### 2.2 Interaction Principles

- One-screen comprehension first
- Motion should explain metabolism, not decorate the UI
- Charts should support the central body visualization
- Every major surface should lead to a decision: eat less, move more, or stay on track

### 2.3 Tone

- Calm
- Precise
- Warm
- Intelligent
- Encouraging without being childish

## 3. Design Tokens

### 3.1 Color System

#### Base

- `bg.primary`: `#0B1020`
- `bg.secondary`: `#12192C`
- `bg.tertiary`: `#1B2338`
- `surface.glass`: `#FFFFFF14`
- `surface.card`: `#10182A`
- `surface.cardElevated`: `#16213A`
- `stroke.soft`: `#FFFFFF14`
- `stroke.medium`: `#FFFFFF26`

#### Text

- `text.primary`: `#F5F7FF`
- `text.secondary`: `#B7C0D9`
- `text.tertiary`: `#7F89A8`
- `text.inverse`: `#09101F`

#### Energy and Thermal

- `energy.core`: `#FF7A1A`
- `energy.hot`: `#FF9F0A`
- `energy.warm`: `#FFB84D`
- `energy.glow`: `#FF6A3D`
- `energy.soft`: `#FFD6A3`
- `heat.red`: `#FF5E57`
- `heat.magenta`: `#FF4FCB`

#### Status

- `deficit.positive`: `#32D17C`
- `surplus.warning`: `#FFB020`
- `over.intake`: `#FF5A5F`
- `neutral.info`: `#64D2FF`

#### Chart

- `chart.intake`: `#64D2FF`
- `chart.burn`: `#FF8A34`
- `chart.deficitZone`: `#32D17C`
- `chart.surplusZone`: `#FF5A5F`

### 3.2 Gradient Tokens

- `gradient.appBackground`: `#09101F -> #141B31 -> #0E1324`
- `gradient.bodyCore`: `#FF5E57 -> #FF8A34 -> #FFD166`
- `gradient.energyStream`: `#FF4FCB -> #FF7A1A -> #FFE08A`
- `gradient.success`: `#1DBE74 -> #7BE495`

### 3.3 Typography

Use platform-native typography first. Prefer SF Pro / SF Compact.

- `display.large`: 40, semibold
- `display.medium`: 32, semibold
- `title.large`: 28, semibold
- `title.medium`: 22, semibold
- `headline`: 18, medium
- `body`: 16, regular
- `body.small`: 14, regular
- `caption`: 12, medium
- `number.hero`: 42, bold, monospaced digits
- `number.card`: 24, semibold, monospaced digits

### 3.4 Spacing

- `space.4`: 4
- `space.8`: 8
- `space.12`: 12
- `space.16`: 16
- `space.20`: 20
- `space.24`: 24
- `space.32`: 32
- `space.40`: 40

### 3.5 Radius

- `radius.small`: 12
- `radius.medium`: 18
- `radius.large`: 24
- `radius.xlarge`: 32
- `radius.pill`: 999

### 3.6 Shadow and Glow

- `shadow.card`: black 20%, blur 24, y 10
- `shadow.panel`: black 28%, blur 40, y 18
- `glow.energySoft`: `#FF8A34`, opacity 0.28, blur 32
- `glow.energyStrong`: `#FF5E57`, opacity 0.32, blur 56

### 3.7 Material

- Main cards use dark glass with subtle blur
- Body module uses layered additive glow
- Charts use thin luminous strokes, not thick opaque bars

### 3.8 Motion

- `motion.breath`: 3.2s easeInOut infinite
- `motion.energyFlow`: 2.4s linear infinite
- `motion.cardRise`: 0.45s spring
- `motion.chartReveal`: 0.75s easeOut
- `motion.goalPulse`: 1.8s easeInOut infinite

Motion rules:

- Never shake
- Never flash hard red
- Never use literal flame animation
- Use pulse, drift, stream, glow spread, and slow gradient shift

### 3.9 Body Visualization Rules

- Show one calm human silhouette only
- Use internal heat zones in chest, abdomen, thighs, and calves
- Heat intensity maps to burn rate, not body fat
- When deficit is healthy, body core is stable and bright
- When surplus is growing, intake halo becomes larger than output halo
- When inactive for long periods, flow slows and cool regions expand

## 4. Information Architecture

## 4.1 Platform Scope

### Phase 1

- `iPhone`: primary experience
- `Apple Watch`: live burn companion

### Phase 2

- `iPad`: expanded analytics and weekly planning
- `Mac`: dashboard, trends, and coaching mode

### 4.2 iPhone Navigation

Five-tab structure:

1. `Today`
2. `Journey`
3. `Log`
4. `Insights`
5. `Profile`

## 5. Page Definitions

## 5.1 Today

### Purpose

This is the flagship screen. It explains the user’s current body energy state in one glance.

### Key Questions Answered

- What is happening in my body right now?
- How much have I burned?
- How much have I eaten?
- What is my current deficit or surplus?
- What action should I take next?

### Structure

#### A. Top Summary

- greeting or contextual title
- `today burn`
- `current deficit / surplus`
- target status chip such as `on track`, `behind`, `over target`

#### B. Body Energy Hero

- centered human silhouette
- animated thermal flow
- core heat zones
- optional small labels for `BMR`, `digestion`, `workout`
- subtle ambient halo reflecting current metabolic intensity

#### C. Primary Metrics Row

- `intake`
- `burn`
- `deficit`
- `predicted end-of-day`

#### D. Burn Breakdown

- `basal metabolism`
- `digestion`
- `activity`
- `workout`

Each card should show:

- kcal
- share of total burn
- simple trend vs yesterday

#### E. Energy Timeline

- day timeline
- intake spikes
- burn curve
- deficit/surplus background bands

#### F. Next Best Action

- one short recommendation only
- examples:
- `Walk 22 more minutes to hit a 500 kcal deficit`
- `Avoid another 320 kcal meal tonight to stay on target`

### States

- morning: predicted values emphasize plan
- midday: balance emphasis
- evening: final deficit emphasis
- no data: educational onboarding variant

## 5.2 Journey

### Purpose

Translate daily energy balance into weight-loss progress and adherence.

### Structure

- current weight block
- goal weight block
- weekly average deficit
- projected date to target
- adherence ring
- seven-day and thirty-day trends
- milestone cards

### Key Modules

- `weight trend`
- `fat-loss pace`
- `consistency score`
- `weekly burn average`

## 5.3 Log

### Purpose

Make logging fast enough that users actually use it.

### Structure

- segmented entry switch:
- `food`
- `exercise`
- `weight`
- `body state`
- recent entries
- quick-add presets
- photo meal entry placeholder for future phase

### Food Entry Fields

- meal type
- kcal
- protein
- carbs
- fat
- meal time
- note

### Exercise Entry Fields

- workout type
- duration
- intensity
- estimated kcal
- import from Apple Watch if available

## 5.4 Insights

### Purpose

Explain why the user is or is not losing weight.

### Structure

- weekly insight headline
- trend cards
- behavior correlation cards
- high-intake windows
- low-activity windows
- burn efficiency patterns

### Example Insights

- `Most of your weekly surplus happens after 8 PM`
- `Walking days produce the most sustainable deficit`
- `Your intake is stable, but weekend burn drops sharply`

## 5.5 Profile

### Purpose

House user setup, body model inputs, and data permissions.

### Structure

- body stats
- calorie target settings
- deficit goal settings
- HealthKit permissions
- Apple Watch connection status
- units
- notification preferences

## 6. Apple Watch App

## 6.1 Watch Screens

1. `Live Burn`
2. `Workout Burn`
3. `Deficit Ring`
4. `Quick Log`

### Live Burn

- live kcal burn
- current heart rate
- active intensity state
- mini thermal pulse visualization

### Workout Burn

- workout duration
- current burn
- zone indicator
- quick finish action

### Deficit Ring

- daily burn vs intake progress ring
- remaining target

### Quick Log

- water
- snack
- walk
- weight shortcut

## 7. iPad and Mac

## 7.1 iPad

Purpose:

- weekly review
- trend comparison
- plan adjustment

Primary layout:

- body hero on left
- analytics panes on right
- bottom comparison charts

## 7.2 Mac

Purpose:

- detailed analytics
- long-range trend exploration
- coaching mode

Primary layout:

- multi-column dashboard
- bigger charts
- richer tables and filters

## 8. Data Model Requirements

The app should support these data domains:

- user profile
- body metrics
- food intake entries
- activity entries
- workout entries
- passive energy burn
- active energy burn
- digestion estimate
- daily balance summary
- goals and coaching recommendations

## 9. Health and Calculation Model

## 9.1 Burn Components

Total daily burn is defined as:

`total burn = basal metabolism + digestion cost + active movement + workout burn`

### Definitions

- `basal metabolism`: resting energy for vital function and temperature maintenance
- `digestion cost`: thermic effect of food
- `active movement`: walking, standing, non-workout movement
- `workout burn`: deliberate exercise sessions

## 9.2 Balance

`energy balance = intake - total burn`

- positive result: surplus
- negative result: deficit

## 9.3 Goal Logic

The app should promote healthy deficit zones rather than extreme restriction.

Suggested default daily target:

- `mild deficit`: 250 to 350 kcal
- `standard deficit`: 400 to 550 kcal
- `aggressive`: hidden from default UI, advanced only

## 10. MVP Scope

Phase 1 should include only these screens:

1. `Today`
2. `Journey`
3. `Log`
4. `Profile`

Insights can ship as a lighter placeholder in MVP if needed.

## 11. Build Order

### Step 1

- replace default template with app shell
- create token system
- create background and card system

### Step 2

- build `Today` page hero
- build metric cards
- build burn breakdown
- build timeline chart shell

### Step 3

- build `Journey`
- build `Log`
- build `Profile`

### Step 4

- add motion
- add empty-state data
- connect HealthKit

## 12. Engineering Mapping

Recommended SwiftUI module structure:

- `App`
- `DesignSystem`
- `Features/Today`
- `Features/Journey`
- `Features/Log`
- `Features/Insights`
- `Features/Profile`
- `Health`
- `Models`
- `PreviewSupport`

## 13. Immediate Implementation Target

The first implemented screen should be `Today`.

It should include:

- app background gradient
- header
- body energy hero
- intake, burn, deficit cards
- burn breakdown cards
- timeline placeholder
- recommendation card

If this screen feels right, the whole product direction is validated.

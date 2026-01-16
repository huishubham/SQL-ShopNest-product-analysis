# ShopNest – Product Analytics Using SQL Server

ShopNest is a **hypothetical e-commerce platform** built to simulate real-world product analytics workflows similar to GA4, Mixpanel, or Clevertap.  
This project demonstrates how SQL can be used to understand **user behavior, retention, funnels, and experiment performance** to drive data-informed product decisions.

---

## 🎯 Project Objective

The goal of this project is to:
- Analyze user behavior across the product journey
- Identify drop-offs and growth opportunities in the funnel
- Measure short-term and long-term user retention
- Evaluate the impact of product experiments (A/B tests)
- Generate insights that a Product, Growth, or Business team can act upon

---

## 🧱 Dataset Overview

The dataset consists of **event-level user data** spanning multiple months, enabling realistic product analysis.

### Core Tables
- **users** – User signup details
- **events** – User activity events (app_open, product_view, add_to_cart, purchase)
- **orders** – Transactional purchase data
- **ab_tests** – Experiment group assignments (control vs variant)

Event timestamps are generated **relative to signup date**, allowing accurate retention and cohort analysis.

---

## 🔍 Key Analyses Performed

### 1️⃣ Funnel Analysis
Tracked user progression across key stages:
**Outcome:**
- Identified the highest drop-off between *Product View* and *Add to Cart*
- Highlighted friction in the consideration stage of the funnel

---

### 2️⃣ Retention Analysis (Day 1 & Day 7)
Measured how many users returned after signup.

**Outcome:**
- Day-1 retention showed strong initial engagement
- Day-7 retention dropped significantly, indicating a need for better re-engagement strategies such as notifications or offers

---

### 3️⃣ Monthly Cohort Analysis
Grouped users by signup month and tracked retention over time.

**Outcome:**
- Newer cohorts showed improved retention, suggesting recent product or UX improvements
- Older cohorts decayed faster, highlighting onboarding gaps in earlier versions

---

### 4️⃣ Revenue & ARPU Analysis
Calculated:
- Total revenue
- Average Revenue Per User (ARPU)
- Revenue contribution by user segments

**Outcome:**
- A small percentage of users contributed a disproportionately high share of revenue
- Opportunity identified for targeting high-value users with loyalty programs

---

### 5️⃣ A/B Test Analysis
Compared conversion rates between **Control** and **Variant** groups.

**Outcome:**
- Variant group showed higher purchase conversion
- Validated the impact of a hypothetical product or UX change
- Demonstrated how experiments can reduce decision-making based on assumptions

---

## 📊 Key Insights & Learnings

- Funnel analysis is critical for identifying **where users drop off**, not just how many convert
- Retention metrics are more meaningful when events are aligned to signup dates
- Cohort analysis reveals **product improvements over time**, not visible in aggregate metrics
- A/B testing enables confident, data-backed product decisions
- SQL alone can power a complete product analytics workflow without complex tools

---

## 🛠 Tech Stack

- **SQL Server**
- Window functions, CTEs, joins, aggregations
- Product analytics concepts: funnels, cohorts, retention, experimentation

---

## 🚀 Business Impact (Simulated)

If applied to a real product, these insights could:
- Improve conversion rates by fixing funnel bottlenecks
- Increase retention through better onboarding and engagement strategies
- Boost revenue via targeted experiments and personalization
- Support faster, data-driven product decisions

---

## 📌 Why This Project Matters

This project mirrors the real responsibilities of a **Product Analyst**, showcasing:
- Analytical thinking
- Strong SQL skills
- Understanding of product metrics
- Ability to translate data into actionable insights

---

## 👤 Author
**Shubham Panwar**  
Product Analytics | SQL | Data Analysis


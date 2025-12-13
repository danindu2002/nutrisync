"use client";

import featureImg from "@/assets/otherImages/figma-screen-01.png";
import backgroundImg from "@/assets/otherImages/features-bg.jpg";
import { IconButton } from "@mui/material";
import { ArrowBackIosNew, ArrowForwardIos } from "@mui/icons-material";
import { useRef, useState, useEffect } from "react";
import mealLogImg from "@/assets/features/meal-log-ui.png";
import foodScanImg from "@/assets/features/food-scan-ui.png";
import gameChallengesImg from "@/assets/features/gamified-challenges-ui.png";
import mealGenerationImg from "@/assets/features/meal-generation-ui.png";
import healthAwareImg from "@/assets/features/health-condition-aware-ui.png";
import riskPridictionImg from "@/assets/features/risk-predictor-ui.png";

const features = [
  {
    title: "AI-based Daily Meal Logging & Tracking",
    description:
      "Easily log meals with AI assistance, track calories, macros, and nutrients automatically.",
    image: mealLogImg,
  },
  {
    title: "Food Recognition via Photos & Voice",
    description:
      "Identify meals from photos or voice input, estimate portion size, and show nutritional values.",
    image: foodScanImg,
  },
  {
    title: "Gamified Challenges & Rewards",
    description:
      "Daily and weekly health challenges that motivate users with points, badges, and rewards.",
    image: gameChallengesImg,
  },
  {
    title: "AI Food Substitution Suggestions",
    description:
      "Recommends healthier alternatives while keeping familiar taste and cultural preference.",
    image: mealGenerationImg,
  },
  {
    title: "Health Condition Aware Recommendations",
    description:
      "Provides meal suggestions suitable for conditions like diabetes or hypertension to help them manage their health",
    image: healthAwareImg,
  },
  {
    title: "Health Risk Predictions",
    description:
      "Predicts future health risks such as obesity or high cholesterol based on user trends and offer preventive and advising solutions accordingly to mitigate those risks",
    image: riskPridictionImg,
  },
  {
    title: "Health Impact Simulation",
    description:
      "Visualizes long-term effects of a user's diet, including changes in weight and health risk levels comparing their current diet to motivate healthier choices.",
    image: featureImg,
  },
];

export default function FeaturesSection() {
  const scrollRef = useRef<HTMLDivElement | null>(null);
  const [index, setIndex] = useState(0);

  // card width + gap must match the card styles below
  const CARD_WIDTH = 330;
  const GAP = 40;
  const STEP = CARD_WIDTH + GAP;
  const VISIBLE = 3;
  const maxIndex = Math.max(0, features.length - VISIBLE);

  useEffect(() => {
    // scroll to the proper position when index changes
    const left = index * STEP;
    scrollRef.current?.scrollTo({ left, behavior: "smooth" });
  }, [index]);

  const scrollLeft = () => {
    if (features.length <= VISIBLE) {
      setIndex(0);
      return;
    }
    setIndex((prev) => (prev <= 0 ? maxIndex : prev - 1));
  };

  const scrollRight = () => {
    if (features.length <= VISIBLE) {
      setIndex(0);
      return;
    }
    setIndex((prev) => (prev >= maxIndex ? 0 : prev + 1));
  };

  return (
    <section
      id="features"
      style={{
        marginTop: "100px",
        marginLeft: "120px",
        marginRight: "120px",
        position: "relative",
        zIndex: 1,
        // background: "#12131A",
        backgroundImage: `linear-gradient(rgba(31, 34, 37, 0.85) 0%, rgba(40, 11, 11, 0.85)), url(${backgroundImg.src})`,
        backgroundSize: "cover",
        backgroundPosition: "center",
        backgroundRepeat: "no-repeat",
        borderRadius: "40px",
        padding: "40px 100px",
        textAlign: "center",
        color: "#fff",
      }}
    >
      <IconButton
        aria-label="scroll left"
        onClick={scrollLeft}
        style={{
          position: "absolute",
          left: 24,
          top: "50%",
          transform: "translateY(-50%)",
          zIndex: 999,
          background: "transparent",
          color: "#fff",
          border: "1px solid #fff",
        }}
      >
        <ArrowBackIosNew sx={{ fontSize: "small" }} />
      </IconButton>

      <IconButton
        aria-label="scroll right"
        onClick={scrollRight}
        style={{
          position: "absolute",
          right: 24,
          top: "50%",
          transform: "translateY(-50%)",
          zIndex: 999,
          background: "transparent",
          color: "#fff",
          border: "1px solid #fff",
        }}
      >
        <ArrowForwardIos sx={{ fontSize: "small" }} />
      </IconButton>

      {/* Key Feature Badge */}
      <div
        style={{
          background: "#EF4444",
          display: "inline-block",
          padding: "8px 20px",
          borderRadius: "30px",
          marginBottom: "20px",
          fontWeight: 600,
        }}
      >
        Key Feature
      </div>

      {/* Main Title */}
      <h2
        style={{
          fontSize: "48px",
          fontWeight: 700,
          marginBottom: "20px",
        }}
      >
        Powerful features
      </h2>

      {/* Features scroll container */}
      <div
        ref={scrollRef}
        style={{
          display: "flex",
          justifyContent: "flex-start",
          gap: `${GAP}px`,
          flexWrap: "nowrap",
          overflowX: "hidden", // hide scrollbar visually; container will be programmatically scrolled
          padding: "10px 0",
          scrollBehavior: "smooth",
          width: `${VISIBLE * CARD_WIDTH + (VISIBLE - 1) * GAP}px`, // force container to show exactly 3 cards
          margin: "0 auto",
        }}
      >
        {features.map((feature, idx) => (
          <div
            key={idx}
            style={{
              width: `${CARD_WIDTH}px`,
              background: "#ffffff",
              padding: "30px 15px",
              borderRadius: "20px",
              flex: "0 0 auto",
              display: "flex",
              flexDirection: "column",
              minHeight: "420px",
            }}
          >
            <h3
              style={{
                fontSize: "22px",
                color: "#EF4444",
                fontWeight: 600,
                marginBottom: "12px",
              }}
            >
              {feature.title}
            </h3>

            <p
              style={{
                fontSize: "15px",
                color: "#111",
                lineHeight: 1.6,
                marginBottom: "25px",
                flex: "1 0 auto",
              }}
            >
              {feature.description}
            </p>
            <img
              src={feature.image.src}
              alt={feature.title}
              style={{
                margin: "auto",
                width: "85%",
                height: "510px", // fixed image height so all images match
              }}
            />
          </div>
        ))}
      </div>
    </section>
  );
}

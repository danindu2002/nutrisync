"use client";

import backgroundImg from "@/assets/otherImages/features-bg.jpg";
import { IconButton } from "@mui/material";
import { ArrowBackIosNew, ArrowForwardIos } from "@mui/icons-material";
import { useRef, useState, useEffect } from "react";
import { motion } from "framer-motion";
import mealLogImg from "@/assets/features/meal-log-ui.png";
import foodScanImg from "@/assets/features/food-scan-ui.png";
import simulationImg from "@/assets/features/impact-simulation-ui.png";
import gameChallengesImg from "@/assets/features/gamified-challenges-ui.png";
import mealGenerationImg from "@/assets/features/meal-generation-ui.png";
import healthAwareImg from "@/assets/features/health-condition-aware-ui.png";
import riskPridictionImg from "@/assets/features/risk-predictor-ui.png";
import dashboardImg from "@/assets/features/dashboard.png";
import { TypewriterEffectSmooth } from "@/components/ui/typewriter-effect";

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
    title: "Personalized Dashboard & Insights",
    description:
      "A centralized dashboard that presents daily progress, nutrition summaries, goal tracking and AI-driven insights in a clear and smart format.",
    image: dashboardImg,
  },
  {
    title: "Personilzed Health Impact Simulation",
    description:
      "Visualizes long-term effects of a user's diet, including changes in weight and health risk levels comparing their current diet to motivate healthier choices.",
    image: simulationImg,
  },
  {
    title: "View Early Health Risk Predictions",
    description:
      "Predicts future health risks such as obesity or high cholesterol based on user trends and offer preventive and advising solutions accordingly to mitigate those risks",
    image: riskPridictionImg,
  },
  {
    title: "AI Food Substitution Suggestions",
    description:
      "Recommends healthier alternatives while keeping familiar taste and cultural preference.",
    image: mealGenerationImg,
  },
  {
    title: "Gamified Challenges & Rewards",
    description:
      "Daily and weekly health challenges that motivate users with points, badges, and rewards.",
    image: gameChallengesImg,
  },
  {
    title: "Health Condition Aware Recommendations",
    description:
      "Provides meal suggestions suitable for conditions like diabetes or hypertension to help them manage their health",
    image: healthAwareImg,
  },

];

export default function FeaturesSection() {
  const scrollRef = useRef<HTMLDivElement | null>(null);
  const [index, setIndex] = useState(0);


  const CARD_WIDTH = 330;
  const GAP = 40;
  const STEP = CARD_WIDTH + GAP;
  const VISIBLE = 3;
  const maxIndex = Math.max(0, features.length - VISIBLE);

  const words = [
    {
      text: "Powerful",
      className: "text-white",
    },
    {
      text: "Features",
      className: "text-red-500 dark:text-blue-500",
    },
  ];

  useEffect(() => {
    // scroll to the proper position when index changes
    const left = index * STEP;
    scrollRef.current?.scrollTo({ left, behavior: "smooth" });
  }, [index]);

  const [scrollDirection, setScrollDirection] = useState<"left" | "right">("right");

  const scrollLeft = () => {
    if (features.length <= VISIBLE) {
      setIndex(0);
      return;
    }
    setScrollDirection("left");
    setIndex((prev) => (prev <= 0 ? maxIndex : prev - 1));
  };

  const scrollRight = () => {
    if (features.length <= VISIBLE) {
      setIndex(0);
      return;
    }
    setScrollDirection("right");
    setIndex((prev) => (prev >= maxIndex ? 0 : prev + 1));
  };


  return (

    <section
      id="features"
      style={{
        marginTop: "60px",
        marginLeft: "120px",
        marginRight: "120px",
        position: "relative",
        zIndex: 1,
        backgroundImage: `linear-gradient(rgba(31, 34, 37, 0.85) 0%, rgba(40, 11, 11, 0.85)), url(${backgroundImg.src})`,
        backgroundSize: "cover",
        backgroundPosition: "center",
        backgroundRepeat: "no-repeat",
        borderRadius: "40px",
        padding: "40px 100px",
        textAlign: "center",
        color: "#fff",
        overflow: "hidden",
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

      <h2
        style={{
          fontSize: "48px",
          fontWeight: 700,
          marginBottom: "25px",
          display: "flex",
          justifyContent: "center",
          textAlign: "center",
        }}
      >
        <TypewriterEffectSmooth words={words} />
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
        {features.map((feature, idx) => {
          const enteringIndex = scrollDirection === "right" ? index + VISIBLE - 1 : index;
          const isEnteringCard = idx === enteringIndex;

          return (
            <motion.div
              key={isEnteringCard ? `entering-${idx}` : `card-${idx}`}
              initial={isEnteringCard ? { opacity: 0, scale: 0.96 } : false}
              animate={isEnteringCard ? { opacity: 1, scale: 1 } : false}
              transition={{
                duration: 0.35,
                ease: "linear",
              }}
              style={{
                width: `${CARD_WIDTH}px`,
                background: "#ffffffff",
                padding: "30px 15px",
                borderRadius: "20px",
                flex: "0 0 auto",
                display: "flex",
                flexDirection: "column",
                minHeight: "420px",
                transformOrigin: "center center",
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
                  color: "#424242ff",
                  lineHeight: 1.5,
                  marginBottom: "25px",
                  flex: "1 0 auto",
                }}
              >
                {feature.description}
              </p>
              <motion.div
                whileHover={{
                  scale: 1.01,
                  y: -6,
                }}
                transition={{
                  type: "spring",
                  stiffness: 180,
                  damping: 18,
                  mass: 0.6,
                }}
                style={{
                  margin: "auto",
                  width: "85%",
                }}
              >
                <motion.img
                  src={feature.image.src}
                  alt={feature.title}
                  style={{
                    width: "100%",
                    height: "510px",
                    objectFit: "contain",
                    willChange: "transform",
                  }}
                  draggable={false}
                />
              </motion.div>
            </motion.div>
          );
        })}

      </div>
    </section>
  );
}

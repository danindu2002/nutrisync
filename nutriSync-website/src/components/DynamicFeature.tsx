"use client"

import { LayoutGroup, motion } from "motion/react"

import { TextRotate } from "@/components/ui/text-rotate"

function Preview() {
  return (
    <div className="w-full h-full text-2xl sm:text-3xl md:text-3.5xl flex flex-row items-center font-overusedGrotesk dark:text-muted text-foreground font-medium overflow-hidden sm:pt-2 md:pt-6">
      <LayoutGroup>
        <motion.p className="flex whitespace-pre" layout>
          <motion.span
            className="pt-0.5 sm:pt-1 md:pt-2"
            layout
            transition={{ type: "spring", damping: 30, stiffness: 400 }}
          >
            {/* ✓ {" "} */}
          </motion.span>
          <TextRotate
            texts={[
              "AI Food Recognition",
              "Personalized Diet Plan Generation",
              "Condition-Based Recommendations",
              "AI Food Substitution Suggestions",
              "AI Health Risk Predictions",
              "Health Impact Simulations",
              "Gamified Healthy Challenges",
            ]}
            mainClassName="text-white px-2 sm:px-2 md:px-3 bg-[#EF4444] overflow-hidden py-0.5 sm:py-1 md:py-2 justify-center rounded-lg"
            staggerFrom={"last"}
            initial={{ y: "100%" }}
            animate={{ y: 0 }}
            exit={{ y: "-120%" }}
            staggerDuration={0.025}
            splitLevelClassName="overflow-hidden pb-0.5 sm:pb-1 md:pb-1"
            transition={{ type: "spring", damping: 30, stiffness: 400 }}
            rotationInterval={4000}
          />
        </motion.p>
      </LayoutGroup>
    </div>
  )
}

export { Preview }

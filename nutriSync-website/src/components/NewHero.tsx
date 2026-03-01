"use client";

import { motion } from "framer-motion";
import Image from "next/image";
import { AuroraBackground } from "@/components/ui/aurora-background";
import { Preview } from "@/components/DynamicFeature";

export default function NewHero() {
    return (
        <AuroraBackground>
            <div id="home" className="relative min-h-screen flex items-center">
                <div className="container mx-auto w-full px-5 sm:px-8 lg:px-16 xl:px-24 2xl:px-38">

                    <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 lg:gap-20 xl:gap-25 items-center">

                        {/* LEFT: TEXT */}
                        <motion.div
                            initial={{ opacity: 0, x: -50 }}
                            whileInView={{ opacity: 1, x: 0 }}
                            transition={{ duration: 0.9, ease: "easeInOut" }}
                            viewport={{ once: true }}
                            className="max-w-xl xl:max-w-2xl 2xl:max-w-3xl"
                        >
                            <h2 className="
                text-4xl sm:text-5xl lg:text-5xl xl:text-5xl 2xl:text-6xl
                font-extrabold leading-tight
                text-gray-900 dark:text-white
              ">
                                Play Healthy. <br />
                                Sync Your Plate. <br />
                                Shape Your Life.
                            </h2>
                            <Preview />
                            <p className="
                mt-5 sm:mt-6 lg:mt-8
                text-base sm:text-lg lg:text-xl xl:text-2xl
                text-gray-700 dark:text-neutral-300
                max-w-prose
              " style={{ fontSize: "130%" }}>
                                Turn healthy living into a game! NutriSync uses AI to track meals,
                                recommend smarter swaps, and reward your progress. Every healthy
                                choice gets you closer to your goals.
                            </p>

                        </motion.div>

                        {/* RIGHT: IMAGE */}
                        <motion.div
                            initial={{ opacity: 0, x: 60, scale: 0.95 }}
                            whileInView={{ opacity: 1, x: 0, y:11, scale: 1 }}
                            transition={{ duration: 1, ease: "easeInOut", delay: 0.2 }}
                            viewport={{ once: true }}
                            className="relative flex justify-center lg:justify-end"
                            animate={{ y: [0, -12, 0] }}
                        >
                            <Image
                                src="/images/phone.png"
                                alt="NutriSync mobile app"
                                width={620}
                                height={1240}
                                style={{ width: "85%", height: "auto", paddingTop: "50px" }}
                                className="drop-shadow-2xl"
                                priority
                            />
                        </motion.div>

                    </div>
                </div>
            </div>
        </AuroraBackground>
    );
}

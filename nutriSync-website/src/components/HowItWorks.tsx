import { UserCircle, Target, UserPlus, Sparkles } from "lucide-react";

const steps = [
  {
    icon: UserPlus,
    title: "Create an Account",
    description:
      "Sign up quickly to start your personalized nutrition journey.",
    step: "01",
  },
  {
    icon: UserCircle,
    title: "Tell Us About You",
    description:
      "Share your dietary preferences, allergies, and health goals in minutes.",
    step: "02",
  },
  {
    icon: Target,
    title: "Get Your Plan",
    description:
      "Receive a personalized weekly meal plan designed just for you.",
    step: "03",
  },
  {
    icon: Sparkles,
    title: "Track Progress",
    description:
      "Monitor your nutrition journey and achieve your health goals.",
    step: "04",
  },
];

export const HowItWorks = () => {
  return (
    <section className="py-20 bg-background" id="how-it-works">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-5xl font-bold mb-4">How It Works</h2>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            Start your healthy eating journey in four simple steps
          </p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8 max-w-6xl mx-auto">
          {steps.map((step, index) => (
            <div key={index} color="red" className="text-center relative">
              <div className="bg-primary/10 rounded-full w-20 h-20 flex items-center justify-center mx-auto mb-6 relative">
                <step.icon
                  stroke="#EF4444"
                  className="w-10 h-10 text-primary"
                />
                <span className="absolute -top-2 -right-2 bg-[#7e7c7c] text-secondary-foreground rounded-full w-8 h-8 flex items-center justify-center text-sm font-bold">
                  {step.step}
                </span>
              </div>
              <h3 className="text-xl font-semibold mb-3">{step.title}</h3>
              <p className="text-muted-foreground">{step.description}</p>

              {index < steps.length - 1 && (
                <div className="hidden lg:block absolute top-10 left-[60%] w-[80%] h-0.5 bg-border" />
              )}
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

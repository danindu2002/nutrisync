import { Button } from "@/components/items/button";
import { Check } from "lucide-react";

const plans = [
  {
    name: "Basic",
    price: "Free",
    period: "/month",
    description: "Perfect for getting started",
    features: [
      "Weekly meal plans",
      "100+ recipes",
      "Basic shopping lists",
      "Mobile app access",
    ],
    popular: false,
  },
  {
    name: "Premium",
    price: "$9",
    period: "/month",
    description: "Most popular choice",
    features: [
      "Everything in Basic",
      "Unlimited meal plans",
      "1000+ premium recipes",
      "Smart shopping lists",
      "Nutritional tracking",
      "Priority support",
    ],
    popular: true,
  },
  {
    name: "Family",
    price: "$19",
    period: "/month",
    description: "Best for families",
    features: [
      "Everything in Premium",
      "Up to 6 family members",
      "Kid-friendly recipes",
      "Meal prep guides",
      "Grocery delivery integration",
      "Custom meal requests",
    ],
    popular: false,
  },
];

export const Pricing = () => {
  return (
    <section className="py-20 bg-muted/30">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-5xl font-bold mb-4">Choose Your Plan</h2>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            Start with a 14-day free trial. Cancel anytime.
          </p>
        </div>
        
        <div className="grid md:grid-cols-3 gap-8 max-w-6xl mx-auto">
          {plans.map((plan, index) => (
            <div
              key={index}
              className={`bg-card rounded-2xl p-8 border-2 transition-all duration-300 hover:shadow-xl ${
                plan.popular
                  ? "border-[#27b07d] shadow-lg scale-105"
                  : "border-border hover:border-primary/30"
              }`}
            >
              {plan.popular && (
                <div className="bg-[#27b07d] text-primary-foreground text-sm font-semibold px-4 py-1 rounded-full inline-block mb-4">
                  Most Popular
                </div>
              )}
              <h3 className="text-2xl font-bold mb-2">{plan.name}</h3>
              <p className="text-muted-foreground mb-6">{plan.description}</p>
              <div className="mb-6">
                <span className="text-5xl font-bold">{plan.price}</span>
                <span className="text-muted-foreground text-lg">{plan.period}</span>
              </div>
              {/* <Button 
                variant={plan.popular ? "hero" : "outline"} 
                className={plan.popular ? "bg-[#27b07d] w-full mb-6" : "w-full mb-6"}
                size="lg"
              >
                Start Free Trial
              </Button> */}
              <ul className="space-y-3">
                {plan.features.map((feature, featureIndex) => (
                  <li key={featureIndex} className="flex items-start gap-3">
                    <Check stroke="#27b07d" className="w-5 h-5 text-primary flex-shrink-0 mt-0.5" />
                    <span className="text-sm">{feature}</span>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

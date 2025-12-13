"use client";

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "default" | "outline" | "ghost";
  size?: "sm" | "lg";
  children: React.ReactNode;
}

const Button = ({
  variant = "default",
  size = "sm",
  className = "",
  children,
  ...props
}: ButtonProps) => {
  const baseClasses =
    "inline-flex items-center justify-center font-medium transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-white/20 disabled:pointer-events-none disabled:opacity-50";

  const variants = {
    default: "bg-white text-black hover:bg-gray-100",
    outline:
      "border border-white/20 bg-white/5 backdrop-blur-xl text-white hover:bg-white/10 hover:border-white/30",
    ghost: "text-white/90 hover:text-white hover:bg-white/10",
  };

  const sizes = {
    sm: "h-9 px-4 py-2 text-sm",
    lg: "px-8 py-6 text-lg",
  };

  return (
    <button
      className={`group relative overflow-hidden rounded-full ${baseClasses} ${variants[variant]} ${sizes[size]} ${className}`}
      {...props}
      style={{ cursor: "pointer" }}
    >
      <span className="relative z-10 flex items-center">{children}</span>
      <div className="absolute inset-0 -top-2 -bottom-2 bg-gradient-to-r from-transparent via-white/20 to-transparent skew-x-12 -translate-x-full group-hover:translate-x-full transition-transform duration-1000 ease-out" />
    </button>
  );
};

export default Button;

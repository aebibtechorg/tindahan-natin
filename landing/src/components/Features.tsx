import React from 'react';
import { motion } from 'framer-motion';
import { Package, Map, Globe, ShieldCheck, Zap, Heart } from 'lucide-react';

const features = [
  {
    title: "Inventory Management",
    description: "Keep track of your products, stock levels, and pricing in real-time with automated alerts.",
    icon: <Package size={24} className="text-primary" />,
    color: "rgba(30, 136, 229, 0.1)"
  },
  {
    title: "Visual Store Map",
    description: "Design your store layout digitally. Organize shelves and locate products instantly.",
    icon: <Map size={24} className="text-primary" />,
    color: "rgba(255, 179, 0, 0.1)"
  },
  {
    title: "Family & Staff Links",
    description: "Share your store's live inventory with family members, tinderos, and tinderas for seamless coordination.",
    icon: <Globe size={24} className="text-primary" />,
    color: "rgba(30, 136, 229, 0.1)"
  },
  {
    title: "Offline First",
    description: "Manage your store even without an internet connection. Data syncs automatically when back online.",
    icon: <ShieldCheck size={24} className="text-primary" />,
    color: "rgba(30, 136, 229, 0.1)"
  },
  {
    title: "Blazing Fast",
    description: "Built with the latest technologies to ensure a smooth and responsive experience.",
    icon: <Zap size={24} className="text-primary" />,
    color: "rgba(255, 179, 0, 0.1)"
  },
  {
    title: "Community Driven",
    description: "Designed for and by sari-sari store owners to solve real-world daily challenges.",
    icon: <Heart size={24} className="text-primary" />,
    color: "rgba(30, 136, 229, 0.1)"
  }
];

const Features = () => {
  return (
    <section id="features" className="features-section">
      <div className="container">
        <div className="section-header">
          <h2 className="section-title">Everything you need to succeed</h2>
          <p className="section-subtitle">Powerful tools designed specifically for the modern Filipino sari-sari store.</p>
        </div>
        
        <div className="features-grid">
          {features.map((feature, index) => (
            <motion.div 
              key={index}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: index * 0.1 }}
              whileHover={{ y: -5, boxShadow: "0 20px 40px -15px rgba(0,0,0,0.1)" }}
              className="feature-card"
            >
              <div className="icon-wrapper" style={{ backgroundColor: feature.color }}>
                {feature.icon}
              </div>
              <h3>{feature.title}</h3>
              <p>{feature.description}</p>
            </motion.div>
          ))}
        </div>
      </div>

      <style>{`
        .features-section {
          padding: 8rem 0;
          background: #F7F9FC;
        }
        .section-header {
          text-align: center;
          margin-bottom: 5rem;
        }
        .section-title {
          font-size: 2.5rem;
          font-weight: 800;
          color: #1a1a1a;
          margin-bottom: 1rem;
        }
        .section-subtitle {
          font-size: 1.125rem;
          color: #4b5563;
          max-width: 600px;
          margin: 0 auto;
        }
        .features-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
          gap: 2rem;
        }
        .feature-card {
          background: white;
          padding: 2.5rem;
          border-radius: 24px;
          border: 1px solid rgba(0,0,0,0.03);
          transition: all 0.3s ease;
        }
        .icon-wrapper {
          width: 56px;
          height: 56px;
          border-radius: 16px;
          display: flex;
          align-items: center;
          justify-content: center;
          margin-bottom: 1.5rem;
          color: #1E88E5;
        }
        .feature-card h3 {
          font-size: 1.25rem;
          font-weight: 700;
          margin-bottom: 1rem;
          color: #1a1a1a;
        }
        .feature-card p {
          color: #4b5563;
          line-height: 1.6;
          margin: 0;
        }
      `}</style>
    </section>
  );
};

export default Features;

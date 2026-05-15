import React from 'react';
import { motion } from 'framer-motion';
import { ShoppingBag, ArrowRight } from 'lucide-react';

const Hero = () => {
  return (
    <section className="hero-overflow">
      <div className="shimmer-overlay"></div>
      <div className="container hero-container">
        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8 }}
          className="hero-content"
        >
          <motion.div 
            className="badge"
            initial={{ scale: 0.8, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{ delay: 0.2, type: "spring", stiffness: 200 }}
          >
            <span>✨ New: Family & Staff Links</span>
          </motion.div>
          
          <h1 className="hero-title">
            Your sari-sari store, <br />
            <span className="shimmer-text">modernized.</span>
          </h1>
          
          <p className="hero-subtitle">
            Tindahan Natin helps you manage inventory, organize shelves visually, 
            and empower family members, tinderos, and tinderas that run your store.
          </p>
          
          <div className="hero-actions">
            <motion.button 
              whileHover={{ scale: 1.05, boxShadow: "0 10px 25px -5px rgba(30, 136, 229, 0.4)" }}
              whileTap={{ scale: 0.95 }}
              className="btn-primary"
              onClick={() => alert('Download coming soon!')}
            >
              Get Started Free <ArrowRight size={18} />
            </motion.button>
            <motion.button 
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              className="btn-secondary"
            >
              View Demo
            </motion.button>
          </div>
        </motion.div>

        <motion.div 
          initial={{ opacity: 0, x: 50 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 1, delay: 0.4 }}
          className="hero-visual"
        >
          <div className="phone-mockup">
            <div className="phone-screen">
               <div className="app-header">
                 <div className="app-logo-mini"></div>
               </div>
               <div className="app-content-mock">
                 <div className="mock-card"></div>
                 <div className="mock-card"></div>
                 <div className="mock-card"></div>
               </div>
            </div>
            <motion.div 
               animate={{ 
                 y: [0, -10, 0],
                 rotate: [0, 5, 0]
               }}
               transition={{ duration: 4, repeat: Infinity, ease: "easeInOut" }}
               className="floating-icon icon-1"
            >
              <ShoppingBag color="#FFB300" size={32} fill="#FFB300" />
            </motion.div>
          </div>
        </motion.div>
      </div>

      <style>{`
        .hero-overflow {
          position: relative;
          padding: 8rem 0;
          background: #ffffff;
          overflow: hidden;
        }

        .shimmer-overlay {
          position: absolute;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background: radial-gradient(circle at 50% 50%, rgba(30, 136, 229, 0.03) 0%, transparent 70%);
          pointer-events: none;
        }

        .hero-container {
          display: grid;
          grid-template-columns: 1.2fr 1fr;
          align-items: center;
          gap: 4rem;
        }

        @media (max-width: 768px) {
          .hero-container {
            grid-template-columns: 1fr;
            text-align: center;
          }
          .hero-actions {
            justify-content: center;
          }
        }

        .badge {
          display: inline-block;
          padding: 0.5rem 1rem;
          background: rgba(30, 136, 229, 0.1);
          color: #1E88E5;
          border-radius: 99px;
          font-weight: 700;
          font-size: 0.875rem;
          margin-bottom: 1.5rem;
        }

        .hero-title {
          font-size: 4rem;
          font-weight: 900;
          line-height: 1.05;
          margin: 0 0 1.5rem;
          color: #1a1a1a;
          letter-spacing: -0.02em;
        }

        .shimmer-text {
          background: linear-gradient(90deg, #1E88E5, #FFB300, #1E88E5);
          background-size: 200% auto;
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          animation: shimmer 4s linear infinite;
        }

        @keyframes shimmer {
          to { background-position: 200% center; }
        }

        .hero-subtitle {
          font-size: 1.25rem;
          line-height: 1.6;
          color: #4b5563;
          margin-bottom: 2.5rem;
          max-width: 540px;
        }

        .hero-actions {
          display: flex;
          gap: 1rem;
        }

        .btn-primary {
          background: #1E88E5;
          color: white;
          border: none;
          padding: 1rem 2rem;
          border-radius: 12px;
          font-weight: 700;
          font-size: 1.1rem;
          cursor: pointer;
          display: flex;
          align-items: center;
          gap: 0.5rem;
        }

        .btn-secondary {
          background: white;
          color: #1E88E5;
          border: 2px solid #e5e7eb;
          padding: 1rem 2rem;
          border-radius: 12px;
          font-weight: 700;
          font-size: 1.1rem;
          cursor: pointer;
        }

        .phone-mockup {
          position: relative;
          width: 300px;
          height: 600px;
          background: #111;
          border-radius: 40px;
          border: 8px solid #222;
          box-shadow: 0 50px 100px -20px rgba(0,0,0,0.25);
          margin: 0 auto;
        }

        .phone-screen {
          width: 100%;
          height: 100%;
          background: #F7F9FC;
          border-radius: 32px;
          overflow: hidden;
          padding: 1.5rem;
        }

        .app-header {
           height: 40px;
           background: white;
           border-radius: 8px;
           margin-bottom: 1.5rem;
           box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .mock-card {
          height: 80px;
          background: white;
          border-radius: 12px;
          margin-bottom: 1rem;
          box-shadow: 0 4px 6px rgba(0,0,0,0.02);
        }

        .floating-icon {
          position: absolute;
          background: white;
          padding: 1rem;
          border-radius: 20px;
          box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1);
        }

        .icon-1 {
          top: 20%;
          right: -40px;
        }
      `}</style>
    </section>
  );
};

export default Hero;

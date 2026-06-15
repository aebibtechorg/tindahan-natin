import React from 'react';
import { motion } from 'framer-motion';
import { Search, MapPin, DollarSign, Box, MessageSquare, BookOpen } from 'lucide-react';

const chatMessages = [
  { sender: 'me', text: 'Ma, magkano po yung Brand X shampoo?', delay: 1 },
  { sender: 'mama', text: '₱8.00 yung sachet nak, check mo kung pink o green.', delay: 2.5 },
  { sender: 'me', text: 'Saan po nakalagay yung Brand X shampoo?', delay: 4 },
  { sender: 'mama', text: 'Nasa yellow basket sa pangalawang estante sa kanan, katabi ng conditioner.', delay: 5.5 },
  { sender: 'me', text: 'Saan po nakalagay yung lalagyan ng Brand X shampoo? Paubos na kasi rito sa harap.', delay: 7 },
  { sender: 'mama', text: 'Nasa bodega sa likod, sa ilalim ng lamesa tabi ng mga sako ng bigas.', delay: 8.5 },
  { sender: 'me', text: 'Ma, nandito rin si Aling Nena. Pa-lista daw po ng nakuha niyang shampoo saka magbabayad din daw po ng konti sa utang.', delay: 10 },
  { sender: 'mama', text: 'Pindutin mo lang yung Lista button sa app nak. Nandoon na yung record niya, lagay mo na lang para sync agad.', delay: 12 },
];

const Story = () => {
  return (
    <section className="story-section">
      <div className="container">
        <div className="section-header">
          <span className="story-badge">
            <MessageSquare size={16} /> Born from a Real Story
          </span>
          <h2 className="section-title">Built for the "Tinderas" and "Tinderos"</h2>
          <p className="section-subtitle">
            Ever had to run a sari-sari store with zero onboarding? Here is why we built Tindahan Natin.
          </p>
        </div>

        <div className="story-grid">
          {/* Chat Column */}
          <motion.div 
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.8 }}
            className="chat-container-wrapper"
          >
            <div className="chat-window">
              <div className="chat-header">
                <div className="avatar-wrapper">
                  <div className="avatar">👩‍🦳</div>
                  <span className="status-dot"></span>
                </div>
                <div className="chat-header-info">
                  <h4>Mama (Store Owner)</h4>
                  <p>Active 5m ago</p>
                </div>
              </div>

              <div className="chat-body">
                {chatMessages.map((msg, index) => (
                  <motion.div
                    key={index}
                    initial={{ opacity: 0, y: 15, scale: 0.95 }}
                    whileInView={{ opacity: 1, y: 0, scale: 1 }}
                    viewport={{ once: true }}
                    transition={{ delay: msg.delay, duration: 0.4 }}
                    className={`chat-bubble-wrapper ${msg.sender}`}
                  >
                    {msg.sender === 'mama' && <span className="chat-avatar">👩‍🦳</span>}
                    <div className={`chat-bubble ${msg.sender}`}>
                      <p>{msg.text}</p>
                    </div>
                  </motion.div>
                ))}

                {/* Animated Typing Indicator for Mama initially, then hidden */}
                <motion.div
                  initial={{ opacity: 1 }}
                  animate={{ opacity: 0 }}
                  transition={{ delay: 14, duration: 0.5 }}
                  className="typing-indicator-wrapper"
                >
                  <span className="chat-avatar">👩‍🦳</span>
                  <div className="typing-indicator">
                    <span></span>
                    <span></span>
                    <span></span>
                  </div>
                </motion.div>
              </div>
            </div>
            <p className="story-caption">
              💬 Standard "Messenger support" when accommodating customers while Mama is away.
            </p>
          </motion.div>

          {/* Solution Column */}
          <motion.div 
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.8, delay: 0.2 }}
            className="solution-showcase"
          >
            <div className="app-mockup">
              <div className="app-mock-search">
                <Search size={18} className="search-icon" />
                <span className="search-placeholder">Brand X shampoo</span>
              </div>

              <div className="app-mock-results">
                <motion.div 
                  initial={{ opacity: 0, x: 20 }}
                  whileInView={{ opacity: 1, x: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: 2, duration: 0.6 }}
                  className="info-card price-card"
                >
                  <div className="info-icon price-icon">
                    <DollarSign size={20} />
                  </div>
                  <div className="info-content">
                    <h5>"Magkano yung X shampoo?"</h5>
                    <h3>₱8.00 <span className="unit">per sachet</span></h3>
                    <p className="subtext">Mama logged it in the <strong>Products list</strong>, so you don't have to guess.</p>
                  </div>
                </motion.div>

                <motion.div 
                  initial={{ opacity: 0, x: 20 }}
                  whileInView={{ opacity: 1, x: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: 5, duration: 0.6 }}
                  className="info-card location-card"
                >
                  <div className="info-icon location-icon">
                    <MapPin size={20} />
                  </div>
                  <div className="info-content">
                    <h5>"Saan nakalagay yung X shampoo?"</h5>
                    <h3>Shelf 2, Yellow Basket</h3>
                    <p className="subtext">Written right in the product's <strong>Shelf field</strong>.</p>
                  </div>
                </motion.div>

                <motion.div 
                  initial={{ opacity: 0, x: 20 }}
                  whileInView={{ opacity: 1, x: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: 8, duration: 0.6 }}
                  className="info-card storage-card"
                >
                  <div className="info-icon storage-icon">
                    <Box size={20} />
                  </div>
                  <div className="info-content">
                    <h5>"Saan nakalagay yung lalagyan?"</h5>
                    <h3>Backroom (Behind Counter)</h3>
                    <p className="subtext">Spotted instantly on your digital <strong>Store Map</strong>.</p>
                  </div>
                </motion.div>

                <motion.div 
                  initial={{ opacity: 0, x: 20 }}
                  whileInView={{ opacity: 1, x: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: 11, duration: 0.6 }}
                  className="info-card credit-card"
                >
                  <div className="info-icon credit-icon">
                    <BookOpen size={20} />
                  </div>
                  <div className="info-content">
                    <h5>"Pa-lista daw sabi ni Aling Nena..."</h5>
                    <h3>₱120.00 <span className="unit">current tab</span></h3>
                    <p className="subtext">Recorded instantly under her name in the <strong>Lista</strong> ledger.</p>
                  </div>
                </motion.div>
              </div>
            </div>

            <div className="solution-features">
              <h3>Run the store with confidence, even on day one:</h3>
              <ul>
                <li>
                  <strong>No more pricing guesswork:</strong> Quickly search any product to find its exact price. No need to text Mama to ask <em>"Magkano?"</em> while a customer is waiting.
                </li>
                <li>
                  <strong>Find items on the floor instantly:</strong> Skip the search. Just read the product's <strong>Shelf field</strong> to see exactly which rack, shelf, or basket it belongs to.
                </li>
                <li>
                  <strong>Navigate the physical store map:</strong> View your digital <strong>Visual Store Map</strong> to locate shelves and cabinets, so you know exactly where backup boxes (<em>"yung lalagyan"</em>) are kept.
                </li>
                <li>
                  <strong>Track tabs and payments (Lista):</strong> Record credits and payments instantly. View balances, payment history, and customer limits on the go.
                </li>
              </ul>
            </div>
          </motion.div>
        </div>
      </div>

      <style>{`
        .story-section {
          padding: 8rem 0;
          background: var(--background);
          border-top: 1px solid var(--border);
          border-bottom: 1px solid var(--border);
          position: relative;
        }

        .section-header {
          text-align: center;
          margin-bottom: 5rem;
        }
        .section-title {
          font-size: 2.5rem;
          font-weight: 800;
          color: var(--text);
          margin-bottom: 1rem;
        }
        .section-subtitle {
          font-size: 1.125rem;
          color: var(--text-light);
          max-width: 600px;
          margin: 0 auto;
        }

        .story-badge {
          display: inline-flex;
          align-items: center;
          gap: 0.5rem;
          padding: 0.5rem 1rem;
          background: rgba(30, 136, 229, 0.1);
          color: #1E88E5;
          border-radius: 99px;
          font-weight: 700;
          font-size: 0.875rem;
          margin-bottom: 1.5rem;
        }

        .story-grid {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 4rem;
          align-items: flex-start;
          margin-top: 3rem;
        }

        @media (max-width: 992px) {
          .story-grid {
            grid-template-columns: 1fr;
            gap: 3rem;
          }
        }

        /* Messenger Chat UI Styling */
        .chat-container-wrapper {
          display: flex;
          flex-direction: column;
          gap: 1rem;
        }

        .chat-window {
          background: var(--card-bg);
          border-radius: 24px;
          box-shadow: var(--card-shadow);
          border: 1px solid var(--border);
          overflow: hidden;
          display: flex;
          flex-direction: column;
          height: 580px;
        }

        .chat-header {
          display: flex;
          align-items: center;
          gap: 1rem;
          padding: 1rem 1.5rem;
          border-bottom: 1px solid var(--border);
          background: var(--card-bg);
        }

        .avatar-wrapper {
          position: relative;
        }

        .avatar {
          width: 44px;
          height: 44px;
          border-radius: 50%;
          background: #e2e8f0;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 1.5rem;
        }

        .status-dot {
          position: absolute;
          bottom: 2px;
          right: 2px;
          width: 12px;
          height: 12px;
          background: #22c55e;
          border: 2px solid var(--card-bg);
          border-radius: 50%;
        }

        .chat-header-info h4 {
          margin: 0;
          font-size: 1rem;
          font-weight: 700;
          color: var(--text);
        }

        .chat-header-info p {
          margin: 0;
          font-size: 0.8rem;
          color: var(--text-light);
        }

        .chat-body {
          flex: 1;
          padding: 1.5rem;
          overflow-y: auto;
          display: flex;
          flex-direction: column;
          gap: 0.75rem;
          background: var(--card-bg);
        }

        .chat-bubble-wrapper {
          display: flex;
          align-items: flex-end;
          gap: 0.5rem;
          max-width: 75%;
        }

        .chat-bubble-wrapper.me {
          align-self: flex-end;
          max-width: 75%;
        }

        .chat-bubble-wrapper.mama {
          align-self: flex-start;
        }

        .chat-avatar {
          width: 28px;
          height: 28px;
          border-radius: 50%;
          background: #e2e8f0;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 0.9rem;
          flex-shrink: 0;
        }

        .chat-bubble {
          padding: 0.75rem 1rem;
          border-radius: 18px;
          font-size: 0.95rem;
          line-height: 1.4;
        }

        .chat-bubble.me {
          background: #0084FF;
          color: white;
          border-bottom-right-radius: 4px;
        }

        .chat-bubble.mama {
          background: #E4E6EB;
          color: black;
          border-bottom-left-radius: 4px;
        }

        /* Dark mode messenger bubble fallback color adjustments */
        @media (prefers-color-scheme: dark) {
          .chat-bubble.mama {
            background: #3A3B3C;
            color: white;
          }
        }

        .chat-bubble p {
          margin: 0;
        }

        .typing-indicator-wrapper {
          display: flex;
          align-items: center;
          gap: 0.5rem;
          align-self: flex-start;
          margin-top: 0.5rem;
        }

        .typing-indicator {
          background: #E4E6EB;
          padding: 0.75rem 1rem;
          border-radius: 18px;
          display: flex;
          align-items: center;
          gap: 4px;
          height: 36px;
        }

        @media (prefers-color-scheme: dark) {
          .typing-indicator {
            background: #3A3B3C;
          }
        }

        .typing-indicator span {
          width: 6px;
          height: 6px;
          background: var(--text-light);
          border-radius: 50%;
          animation: bounce 1.4s infinite ease-in-out both;
        }

        .typing-indicator span:nth-child(1) { animation-delay: -0.32s; }
        .typing-indicator span:nth-child(2) { animation-delay: -0.16s; }

        @keyframes bounce {
          0%, 80%, 100% { transform: scale(0); }
          40% { transform: scale(1); }
        }

        .story-caption {
          font-size: 0.9rem;
          color: var(--text-light);
          text-align: center;
          margin: 0;
          font-style: italic;
        }

        /* Solution Section Styling */
        .solution-showcase {
          display: flex;
          flex-direction: column;
          gap: 2.5rem;
        }

        .app-mockup {
          background: var(--surface);
          border-radius: 28px;
          border: 1px solid var(--border);
          padding: 1.5rem;
          box-shadow: var(--card-shadow);
        }

        .app-mock-search {
          background: var(--card-bg);
          border-radius: 12px;
          padding: 0.85rem 1.25rem;
          display: flex;
          align-items: center;
          gap: 0.75rem;
          border: 1px solid var(--border);
          margin-bottom: 1.5rem;
        }

        .search-icon {
          color: var(--text-light);
        }

        .search-placeholder {
          color: var(--text);
          font-weight: 600;
          font-size: 1rem;
        }

        .app-mock-results {
          display: flex;
          flex-direction: column;
          gap: 1rem;
        }

        .info-card {
          background: var(--card-bg);
          border-radius: 18px;
          padding: 1.25rem;
          display: flex;
          align-items: center;
          gap: 1.25rem;
          border: 1px solid var(--border);
          box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }

        .info-icon {
          width: 48px;
          height: 48px;
          border-radius: 12px;
          display: flex;
          align-items: center;
          justify-content: center;
          flex-shrink: 0;
        }

        .price-icon { background: rgba(34, 197, 94, 0.1); color: #22c55e; }
        .location-icon { background: rgba(30, 136, 229, 0.1); color: #1E88E5; }
        .storage-icon { background: rgba(255, 179, 0, 0.1); color: #FFB300; }
        .credit-icon { background: rgba(168, 85, 247, 0.1); color: #a855f7; }

        .info-content h5 {
          margin: 0 0 0.25rem 0;
          font-size: 0.85rem;
          font-weight: 700;
          color: var(--text-light);
          text-transform: uppercase;
          letter-spacing: 0.05em;
        }

        .info-content h3 {
          margin: 0 0 0.25rem 0;
          font-size: 1.35rem;
          font-weight: 800;
          color: var(--text);
        }

        .info-content h3 .unit {
          font-size: 0.9rem;
          font-weight: 500;
          color: var(--text-light);
        }

        .info-content .subtext {
          margin: 0;
          font-size: 0.85rem;
          color: var(--text-light);
        }

        .solution-features h3 {
          font-size: 1.35rem;
          font-weight: 800;
          margin: 0 0 1.25rem 0;
          color: var(--text);
        }

        .solution-features ul {
          margin: 0;
          padding: 0;
          list-style: none;
          display: flex;
          flex-direction: column;
          gap: 1.25rem;
        }

        .solution-features li {
          position: relative;
          padding-left: 2rem;
          font-size: 1.05rem;
          line-height: 1.6;
          color: var(--text-light);
        }

        .solution-features li::before {
          content: "✨";
          position: absolute;
          left: 0;
          top: 0.1rem;
          font-size: 1.1rem;
        }

        .solution-features li strong {
          color: var(--text);
          font-weight: 700;
        }
      `}</style>
    </section>
  );
};

export default Story;

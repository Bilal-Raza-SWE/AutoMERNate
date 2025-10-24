// Test MongoDB Atlas Connection
// Author: Muhammad Bilal Raza Attari

import dotenv from 'dotenv';
import mongoose from 'mongoose';
import colors from 'colors';

// Load environment variables
dotenv.config();

const testConnection = async () => {
  try {
    console.log('🔄 Testing MongoDB Atlas connection...'.yellow);
    console.log(`📡 Connecting to: ${process.env.MONGO_URI.replace(/\/\/([^:]+):([^@]+)@/, '//$1:****@')}`.cyan);
    
    const conn = await mongoose.connect(process.env.MONGO_URI);
    
    console.log('✅ MongoDB Atlas Connected Successfully!'.green.bold);
    console.log(`📍 Host: ${conn.connection.host}`.green);
    console.log(`📦 Database: ${conn.connection.name}`.green);
    console.log(`🌐 Connection State: ${conn.connection.readyState === 1 ? 'Connected' : 'Not Connected'}`.green);
    
    // List existing collections
    const collections = await conn.connection.db.listCollections().toArray();
    console.log(`\n📚 Existing Collections (${collections.length}):`);
    if (collections.length > 0) {
      collections.forEach(col => console.log(`   - ${col.name}`.cyan));
    } else {
      console.log('   No collections yet (database is empty)'.yellow);
    }
    
    // Close connection
    await mongoose.connection.close();
    console.log('\n✅ Test completed! Connection closed.'.green);
    process.exit(0);
    
  } catch (error) {
    console.error('❌ MongoDB Atlas Connection Error:'.red.bold);
    console.error(`   Error: ${error.message}`.red);
    
    if (error.message.includes('authentication')) {
      console.log('\n💡 Fix: Check your username and password in MONGO_URI'.yellow);
    } else if (error.message.includes('getaddrinfo')) {
      console.log('\n💡 Fix: Check your internet connection and cluster URL'.yellow);
    } else if (error.message.includes('IP')) {
      console.log('\n💡 Fix: Whitelist your IP address in MongoDB Atlas Network Access'.yellow);
    }
    
    process.exit(1);
  }
};

testConnection();

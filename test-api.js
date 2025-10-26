import fetch from 'node-fetch';

async function testRegister() {
  try {
    const response = await fetch('http://localhost:5002/api/v1/users', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        name: 'Test User4',
        email: 'test4@example.com',
        password: 'password123'
      })
    });
    console.log('Status:', response.status);
    const data = await response.text();
    console.log('Response:', data);
  } catch (error) {
    console.error('Error:', error.message);
  }
}

testRegister();
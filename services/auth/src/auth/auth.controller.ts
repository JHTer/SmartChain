import { Controller, Post, Body, HttpCode, HttpStatus } from '@nestjs/common';

@Controller('auth')
export class AuthController {
  @Post('signup')
  async signup(@Body() signupDto: { email: string; password: string; tenantName: string }) {
    // Temporary response until JWT dependencies are installed
    return {
      message: 'Signup endpoint working',
      user: {
        email: signupDto.email,
        tenant: signupDto.tenantName,
        id: 'temp-id-' + Date.now()
      },
      access_token: 'temp-token-' + Date.now()
    };
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(@Body() loginDto: { email: string; password: string }) {
    // Temporary response until JWT dependencies are installed
    return {
      message: 'Login endpoint working',
      user: {
        email: loginDto.email,
        id: 'temp-id-' + Date.now()
      },
      access_token: 'temp-token-' + Date.now()
    };
  }

  @Post('health')
  @HttpCode(HttpStatus.OK)
  async health() {
    return {
      status: 'Auth service is running',
      timestamp: new Date().toISOString()
    };
  }
} 
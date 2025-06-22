// TEMPORARILY DISABLED - Dependencies not installed yet
// This file will be re-enabled once Passport dependencies are installed

/*
import { ExtractJwt, Strategy } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable } from '@nestjs/common';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env.JWT_SECRET || 'your-secret-key',
    });
  }

  async validate(payload: any) {
    return { userId: payload.sub, email: payload.email, tenantId: payload.tenantId };
  }
}
*/

// Placeholder export to prevent import errors
export class JwtStrategy {} 
export declare class AuthController {
    signup(signupDto: {
        email: string;
        password: string;
        tenantName: string;
    }): Promise<{
        message: string;
        user: {
            email: string;
            tenant: string;
            id: string;
        };
        access_token: string;
    }>;
    login(loginDto: {
        email: string;
        password: string;
    }): Promise<{
        message: string;
        user: {
            email: string;
            id: string;
        };
        access_token: string;
    }>;
    health(): Promise<{
        status: string;
        timestamp: string;
    }>;
}

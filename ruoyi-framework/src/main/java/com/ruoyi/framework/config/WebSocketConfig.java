package com.ruoyi.framework.config;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.messaging.support.MessageHeaderAccessor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

import java.util.List;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    private static final Logger log = LoggerFactory.getLogger(WebSocketConfig.class);

    @Value("${token.secret}")
    private String secret;

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        registry.enableSimpleBroker("/topic");
        registry.setApplicationDestinationPrefixes("/app");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws")
                .setAllowedOriginPatterns("*")
                .withSockJS();
    }

    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {
        registration.interceptors(new ChannelInterceptor() {
            @Override
            public Message<?> preSend(Message<?> message, MessageChannel channel) {
                StompHeaderAccessor accessor = MessageHeaderAccessor.getAccessor(message, StompHeaderAccessor.class);
                if (StompCommand.CONNECT.equals(accessor.getCommand())) {
                    List<String> authHeaders = accessor.getNativeHeader("Authorization");
                    log.info("[WS] CONNECT - authHeaders={}", authHeaders);
                    if (authHeaders != null && !authHeaders.isEmpty()) {
                        String token = authHeaders.get(0);
                        if (token.startsWith("Bearer ")) {
                            token = token.substring(7);
                        }
                        try {
                            Claims claims = Jwts.parser()
                                    .setSigningKey(secret)
                                    .parseClaimsJws(token)
                                    .getBody();
                            String userId = claims.get("user_id", String.class);
                            if (userId == null) {
                                Object uidObj = claims.get("user_id");
                                userId = uidObj != null ? uidObj.toString() : null;
                            }
                            log.info("[WS] JWT parsed - userId={}, claims={}", userId, claims.keySet());
                            if (userId != null) {
                                UsernamePasswordAuthenticationToken auth =
                                    new UsernamePasswordAuthenticationToken(userId, null, List.of());
                                accessor.setUser(auth);
                                log.info("[WS] Principal set to userId={}", userId);
                            } else {
                                log.warn("[WS] No user_id in JWT claims - user needs to re-login");
                            }
                        } catch (Exception e) {
                            log.error("[WS] JWT parse failed: {}", e.getMessage());
                        }
                    }
                } else if (StompCommand.SEND.equals(accessor.getCommand())) {
                    log.info("[WS] SEND - destination={}, user={}", accessor.getDestination(), accessor.getUser());
                }
                return message;
            }
        });
    }
}

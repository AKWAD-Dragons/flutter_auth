package com.example.auth_provider;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;


import com.amazon.identity.auth.device.AuthError;
import com.amazon.identity.auth.device.api.Listener;
import com.amazon.identity.auth.device.api.authorization.AuthCancellation;
import com.amazon.identity.auth.device.api.authorization.AuthorizationManager;
import com.amazon.identity.auth.device.api.authorization.AuthorizeListener;
import com.amazon.identity.auth.device.api.authorization.AuthorizeRequest;
import com.amazon.identity.auth.device.api.authorization.AuthorizeResult;
import com.amazon.identity.auth.device.api.authorization.ProfileScope;
import com.amazon.identity.auth.device.api.workflow.RequestContext;

import java.util.HashMap;

/**
 * FlutterAuthPlugin
 */
public class FlutterAuthPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private static RequestContext requestContext;
    private MethodChannel channel;
    private static Handler handler;
    private static MethodChannel.Result methodResult;
    private static Context applicationContext;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        requestContext = RequestContext.create(flutterPluginBinding.getApplicationContext());
        applicationContext = flutterPluginBinding.getApplicationContext();
        handler = new Handler(Looper.getMainLooper());
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "android/amazon");
        channel.setMethodCallHandler(new MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
                methodResult = result;
                if (call.method.equals("signIn")) {
                    signIn();
                    return;
                }

                if (call.method.equals("signOut")) {
                    signOut();
                }
            }
        });
        initAmazonAuthorizer();
    }


    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        applicationContext = registrar.activeContext().getApplicationContext();
        requestContext = RequestContext.create(applicationContext);

        final MethodChannel channel = new MethodChannel(registrar.messenger(), "android/amazon");
        channel.setMethodCallHandler(new MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
                methodResult = result;
                if (call.method.equals("signIn")) {
                    signIn();
                    return;
                }

                if (call.method.equals("signOut")) {
                    signOut();
                }
            }
        });
        initAmazonAuthorizer();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        methodResult = result;
        if (call.method.equals("signIn")) {
            signIn();
            return;
        }

        if (call.method.equals("signOut")) {
            signOut();
        }
    }


    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private static void initAmazonAuthorizer() {
        requestContext.registerListener(new AuthorizeListener() {

            /* Authorization was completed successfully. */
            @Override
            public void onSuccess(final AuthorizeResult result) {
                final HashMap<String, String> data = new HashMap<>();
                data.put("accessToken", result.getAccessToken());
                data.put("postalCode", result.getUser().getUserPostalCode());
                data.put("userId", result.getUser().getUserId());
                data.put("userEmail", result.getUser().getUserEmail());

                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        methodResult.success(data);
                    }
                });
            }

            @Override
            public void onError(AuthError ae) {
                /* Inform the user of the error */
            }

            /* Authorization was cancelled before it could be completed. */
            @Override
            public void onCancel(AuthCancellation cancellation) {
                /* Reset the UI to a ready-to-login state */
            }
        });


    }

    private static void signIn() {
        AuthorizationManager.authorize(new AuthorizeRequest
                .Builder(requestContext)
                .addScopes(ProfileScope.profile(), ProfileScope.postalCode())
                .build());
    }

    private static void signOut() {
        AuthorizationManager.signOut(applicationContext, new Listener<Void, AuthError>() {
            @Override
            public void onSuccess(Void response) {
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        methodResult.success(true);
                    }
                });
            }

            @Override
            public void onError(AuthError authError) {
                // Log the error
            }
        });
    }
}
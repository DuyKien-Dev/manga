package com.manga.reader.english;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import com.example.ratedialog.RatingDialog;
import com.manga.reader.english.utils.SharedPrefsUtils;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity implements RatingDialog.RatingDialogInterFace{

  private static final String CHANNEL = "samples.flutter.dev";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall call, MethodChannel.Result result) {

        switch (call.method) {
          case "rate":
            rateManual();
            break;
        }
      }
    });

  }
  @Override
  protected void onResume() {
    super.onResume();

  }

  @Override
  protected void onPause() {
    super.onPause();
  }

  public static void rateApp(Context context) {
    Intent intent = new Intent(new Intent(Intent.ACTION_VIEW,
            Uri.parse("http://play.google.com/store/apps/details?id=" + context.getPackageName())));
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

    context.startActivity(intent);

  }

  public void rateAutoAfterRun() {
    int rate = SharedPrefsUtils.getInstance(this).getInt("rate");
    if (rate == 0) {
      SharedPrefsUtils.getInstance(this).putInt("rate", -1);
    } else {
      if (rate == -1) {
        RatingDialog ratingDialog = new RatingDialog(this);
        ratingDialog.setRatingDialogListener(this);
        ratingDialog.showDialog();
        SharedPrefsUtils.getInstance(this).putInt("rate", 5);
      }
    }
  }

  void rateManual() {
    if(SharedPrefsUtils.getInstance(this).getInt("rate")<2){
      RatingDialog ratingDialog = new RatingDialog(this);
      ratingDialog.setRatingDialogListener(this);
      ratingDialog.showDialog();
    }

  }

  @Override
  public void onDismiss() {
  }

  @Override
  public void onSubmit(float rating) {
    if (rating > 3) {
      rateApp(this);
      SharedPrefsUtils.getInstance(this).putInt("rate", 5);
    }
  }

  @Override
  public void onRatingChanged(float rating) {
  }
}

{
  cgi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c5494n3n6l51n1w1vc118zckbqdzk7r6b656hswg72w0bif2ja3";
      type = "gem";
    };
    version = "0.4.1";
  };
  charlock_holmes = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c1dws56r7p8y363dhyikg7205z59a3bn4amnv2y488rrq8qm7ml";
      type = "gem";
    };
    version = "0.7.9";
  };
  github-linguist = {
    dependencies = ["cgi" "charlock_holmes" "mini_mime" "rugged"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i8wfzmgj3ni7zihnf3669ki967f13zw7kpbbmfljf8gzcc879z1";
      type = "gem";
    };
    version = "8.0.1";
  };
  mini_mime = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vycif7pjzkr29mfk4dlqv3disc5dn0va04lkwajlpr1wkibg0c6";
      type = "gem";
    };
    version = "1.1.5";
  };
  rugged = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sccng15h8h3mcjxfgvxy85lfpswbj0nhmzwwsqdffbzqgsb2jch";
      type = "gem";
    };
    version = "1.7.2";
  };
}

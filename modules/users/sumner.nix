{ pkgs, ... }: {
  users.users.sumner = {
    shell = pkgs.zsh;
    isNormalUser = true;
    home = "/home/sumner";
    hashedPassword = "$6$p0WfA2vae4b5QahY$/qCwuUV.tVZEajIq7xcFUqcVD6iXAOK0kVPxki27flq4NXNn1XTTbH4s0RQedyKArAg1D2.Y0V0xQF.B/TME90";
    extraGroups = [
      "audio"
      "networkmanager"
      "wheel" # Enable 'sudo' for the user.
    ];

    # Allow all of my computers to SSH in.
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDasJXb4uvxPh0Z1NLa22dTx42VdWD+utRMbK0WeXS6XakIipx1YPb4yqbtUMJkoTLuFW/BUAEXSiks+ARD3Lc4K/iJeHHXbYvgklvr5dAPV6P2KtiVRZ+ipSLv1TF+al6hVUAnp4PPUQTv+3ZRA64QFrCAt26A7OnxKlowyW2KZVSqAcWPdQEbCdwILRCRIWTpbSj1rDeEsnvmu1G+Id5v7+uybQ+twBHbGpfYH7yWYLEhDtRyYu5SgnBcEh0bqszEgt+iLH/XzTQJILKdDaf4x8j/FJ9Px7+VQVfc+yADZ882ZsFzaxlmn7ndstAssmSSsHfRmNye0exIJqGXdxUfpF3w4h5qnR/0AJM7ljtXuDNOlOxflX0WvZinhhOJ/gF3No8sCXG/OcqlMNyrWd+vpJH4f9Xa0PTOn3Qpltq3YxWOZrWopUIDZw5jSsgLpLfC2NtGE/p5nEFnJCmMqrXPDY7dYS+65qYYjWXCzY3d9i3offwIQtV780Gu1VvT/zE= sumner@coruscant"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDcO1lMaMPbL2cr4XdKc6bQJIbQylIXaYfX0S+NN3z0AMw3HCfsNCwlWoxyjIbZBlP3aSrdTITq3eB0gw3l25029h3Q4Dve+I2hf6jpltaGVlpsyhMN8xu9yoqadd0cG71kn6Wn5/BlpaWZtrJy7Px9luCyeuDx+vkC05CLb28sjwYVdTzbuePygUONL7cH6Xd2ulLDW+dFoZIHwraEsqHk9AQRV3f2hokxG/VpbxbVAY7XNOkIrsfmX6y4IccUddffgs8uqsObHEWniPdWOcEocRJ4exORBoyS5SXvcHzUtGi8Q0jGPfKkSFPEYUNcgw0QlU4dzrT/xqm0COcOoXKK58+tZH/YMu0bshp+vIK3HDCCfcRtuv1ZMF/AFbHdY3fglUu3YK2Jpm5Vr8KzljqQXW3ekboILxZpuP2LA3YErS1lpaj3sbOlsfxNQhG7V8/gqo1PBQ4w//7wlav0TOY5GZD1Tw2lduaSAFuFHxVGBOy4Xu31mxa2Qej5YKc71VU= sumner@coruscant-nixos"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDPswA82WA6tHR8rccfVrmBflIfC9SmZpG1Y+Gr8WPxcMy/fdlOt8zV4FveUA466pu9oOsZKmuz8WlP2RK96mhhf/CB68QyPAObo6NyIKQgDC97owRGpNtGTUw4bWdGT+9VKDcuoJdK0cI1dY3jrhIgKL43rOfBnhJfDEBWpRJFof79AfN+Zcs1hTprCjPbiHdXuc7E+uhvxdKfoC2lTDYneVNFUBubcH6SSCJ27AZURPca2aSMkWgGCVTom1ch4Y8jZ5e6Kg0pNZW8LQoLC/kzdwC/f8DHXPFSFipVP5jJ6qtXWm0WCY62nsuV6GyphmmC2H25gV3GefD1ano2pJixRMfj8Muvwm+XKXD7GqmprEKMr0KZjkMGKq144T31TWG/LXkRKuGmHf9wNx4gmFTr6stG30nDYlhaMf/jpeoSAPV9o48x6DZqgd+ukQHKG/uXIYU9gj6OtFOi5bJQp+64P1pBc78942PdnvgC4Bk2sqOyj8nPFeFZKAURctib38U= sumner@jedha"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9J5GLv9e/k1yDFw/pWyGFcHeRaLMI3j22ihQfGKgfX9Kl3X/R2s5+4a4c98PbPeeO0WlFvu0JiwhT1MLb5Kk5iLxVf8C32kNPQ0kLpa+g/L7YSsvYMThUF8qcLhw0imDVEye4gKrKc6uQDwaCr/Rd+93elfeZ+OQj34czWV1vf4Tnpiad7WZ0IVklN5GQTdVTVPDzjiLaKgl/f3E/wv7DYibDUwwdCBWxo+4RJ9QbSwbgxQykLe3TOydPbwyIk5jmGSdNjtxhT4223lVZICBD2AYf23ERPZz/VtPZvF4qv+55C9YjoatAlW68esKTV3X2qV7K19RbeD58N8Yk16SMgs/HyLzXk4L1pPVNMZVAKX7nqNWnn12VMzHa+DJsEBvcnzwaGsBqEuf3fPzP7Isp9IKwQcBEF+mM1UgGRx8OA5tYt9vOnXtYJG+nOkupfga/fT1Zl9Imao+B0Gz1gG6ywM6bxUr5kkjvuQggc4J6pTslG11IQrnBll7k04vKDtM= sumner@mustafar"
    ];
  };
}

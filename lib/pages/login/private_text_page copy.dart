import 'dart:ui';

import 'package:flutter/material.dart';

class PrivateTextPage extends StatelessWidget {
  double rpx;

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;

    return Scaffold(
        appBar: AppBar(
          primary: true,
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: BackButton(color: Colors.black),
          toolbarHeight: 80 * rpx,
          backgroundColor: Colors.grey[100],
          title: Text(
            '隐私政策',
            style: TextStyle(
                fontSize: 30 * rpx,
                fontWeight: FontWeight.w400,
                color: Colors.black),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(
              left: 25 * rpx, right: 25 * rpx, bottom: 20 * rpx),
          child: ListView(
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'Ms时代用户隐私保护政策',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        height: 2.0)),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '         Ms时代 (“我们”)非常重视用户的隐私和个人信息保护，我们将按照法律法规的要求，采取相应的安全保护措施，尽力保护您的个人信息安全。鉴于此，我们希望通过《Ms时代隐私条款》(“本隐私条款”)向您说明我们在您使用我们的产品与/或服务时如何收集、使用、保存、共享和转让这些信息，以及我们为您提供的访问、更新、删除和保护这些信息的方式。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  )
                ]),
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text:
                      '         在使用Ms时代平台前，请您务必仔细阅读并透彻理解本隐私条款，特别是以粗体/粗体下划线标识的条款，您应重点阅读，在确认充分理解并同意后再开始使用。',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 2.0),
                ),
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: '一、我们如何收集和使用您的信息',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 2.0),
                ),
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text:
                      '个人信息是指以电子或者其他方式记录的能够单独或者与其他信息结合识别特定自然人身份或者反映特定自然人活动情况的各种信息。 ',
                  style:
                      TextStyle(color: Colors.black, fontSize: 14, height: 2.0),
                ),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '个人敏感信息：',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                  TextSpan(
                    text:
                        '指包括身份证件号码、个人生物识别信息、银行账号、财产信息、行踪轨迹、交易信息、14岁以下（含）儿童信息等的个人信息。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  )
                ]),
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text:
                      '（一）为实现我们的产品与/或服务的核心业务功能，您须授权我们收集和使用您个人信息的情形如下（如果您不提供相关信息，您将无法享受我们提供的产品与/或服务）：',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 2.0),
                ),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '1.为注册成为Ms时代APP服务商并使用我们的服务商服务，您需要提供手机号码、密码用于创建Ms时代平台账户。如果您仅需使用浏览、搜索服务，当您首次注册后，您可以修改补充您的昵称、性别、生日、身高、体重，这些信息均属于您的“账户信息”。您补充的账户信息将有助于我们为您提供个性化的商品或服务推荐和更优的购物体验，但如果您不提供这些补充信息，不会影响您网上购物的基本功能。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '2.为了让您快速地找到您所需要的商品与/或服务，Ms时代可能会收集您使用我们的产品与/或服务的设备信息(包括设备名称、设备型号、设备识别码、操作系统和应用程序版本、语言设置、分辨率、服务提供商网络ID(PLMN))、浏览器类型。该等信息属于“非个人信息”，通常被用于下列目的：识别账号异常状态、了解产品适配性、向您提供更契合您需求的页面展示和搜索结果，以及改进我们的服务。如果我们将这类非个人信息与其他信息结合用于识别特定自然人身份，或者将其与个人信息结合使用，则在结合使用期间，这类非个人信息将被视为个人信息，除取得您授权或法律法规另有规定外，我们会将这类信息做匿名化、去标识化处理。 为了向您提供更便捷、更符合您个性化需求的信息展示、搜索及推送服务，我们会',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '通过邮件、短信、邮寄会刊的形式，对本网站注册、购物用户发送订单信息、促销活动等告知服务的权利。如果您不想接收来自我们的邮件、短信或会刊，您可以向我们的客服提出退阅申请。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '3.在您浏览我们网站或客户端的过程中，您可以选择对感兴趣的商品及/或服务进行收藏、添加至购物车、与您感兴趣的品牌建立关注关系、通过我们提供的功能组件向其他第三方分享信息。在您使用上述功能的过程中，我们会收集包括您的收藏及添加购物车的记录、关注关系、分享历史在内的服务日志信息用于实现上述功能及其他我们明确告知的目的。3.在您浏览我们网站或客户端的过程中，您可以选择对感兴趣的商品及/或服务进行收藏、添加至购物车、与您感兴趣的品牌建立关注关系、通过我们提供的功能组件向其他第三方分享信息。在您使用上述功能的过程中，我们会收集包括您的收藏及添加购物车的记录、关注关系、分享历史在内的服务日志信息用于实现上述功能及其他我们明确告知的目的。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '4. 当您在Ms时代平台中订购具体商品及/或服务时，我们会通过系统为您生成购买该商品及/或服务的订单。在下单过程中,您需至少提供您的收货人姓名、收货地址、收货人联系电话，同时该订单中会载明您所购买的商品及/或服务信息、具体订单号、订单创建时间、您应支付的金额，我们收集这些信息是为了帮助您顺利完成交易、保障您的交易安全、查询订单信息、提供客服与售后服务及其他我们明确告知的目的。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '6.在当您在线完成支付后，与Ms时代合作的第三方配送公司(以下简称“配送公司”)将为您完成订单的交付。您知晓并同意配送公司会在上述环节内使用您的订单信息以保证您的订购的商品能够安全送达。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '7.当您与我们联系或提出售中售后、争议纠纷处理申请时，为了保障您的账户及系统安全，我们需要您提供必要的个人信息以核验您的会员身份。 为便于与您联系、尽快帮助您解决问题或记录相关问题的处理方案及结果，我们可能会保存您与我们的通信/通话记录及相关内容（包括账号信息、订单信息、您为了证明相关事实提供的其他信息，或您留下的联系方式信息），如果您针对具体订单进行咨询、投诉或提供建议的，我们会使用您的账号信息和订单信息。 为了提供服务及改进服务质量的合理需要，我们还可能使用的您的其他信息，包括您与客服联系时您提供的相关信息，您参与问卷调查时向我们发送的问卷答复信息。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '8.为提高您使用我们的产品与/或服务时系统的安全性，更准确地预防钓鱼网站欺诈和保护账户安全，我们可能会通过了解您的浏览信息、订单信息、您常用的软件信息、设备信息手段来判断您账户及交易风险、进行身份验证、检测及防范安全事件，并依法采取必要的记录、审计、分析、处置措施。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text:
                      '（二）为使您提升在Ms时代平台上的购物体验，您可选择是否授权我们收集和使用您的个人信息的情形如下（如果您不提供这些个人信息，您依然可以进行网上购物， 但您可能无法使用这些可以为您所带来购物乐趣的附加功能或在购买某些商品时需要重复填写一些信息。）',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 2.0),
                ),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '1.基于位置信息的个性化推荐功能：Ms时代会收集您的位置信息（我们仅收集您当时所处的地理位置，但不会将您各时段的位置信息进行结合以判断您的行踪轨迹）来判断您所处的地点， 自动为您推荐您所在区域可以购买的商品或服务。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '2.基于摄像头（相机）的附加功能：您可以使用这个附加功能完成视频拍摄、拍照、扫码的功能。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '3.基于相册（图片库/视频库）的图片/视频访问及上传的附加功能：您可以在Ms时代平台上传您的照片来实现拍照购物功能和晒单及评价功能，Ms时代会使用您所上传的照片来识别您需要购买的商品或使用包含您所上传图片的评价。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '4.基于通讯录信息的附加服务：我们将在您开启通讯录权限后收集您的通讯录信息使您在购物时可以更便利地取用您通讯录内的联系人信息，无需再手动输入；此外，为提升您在使用我们产品及/或服务过程中的社交互动分享乐趣，与您认识的人分享购物体验，在经您同意的前提下，我们也可能对您联系人的姓名和电话号码进行加密收集，帮助您判断您的通讯录联系人是否同为我们的会员进而在Ms时代为你们的交流建立联系，同时，会员可选择开启或关闭好友隐私权限决定自己是否可被其他会员通过手机号码搜索、联系。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '5.基于日历的附加服务：在您开启我们可读取/写入您日历的权限后，我们将收集您的日历信息用于向您提供购物或领取权益相关记录及提醒。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '上述附加功能可能需要您在您的设备中向我们开启您的地理位置（位置信息）、相机（摄像头）、相册（图片库）以及通讯录及/或日历的访问权限，以实现这些功能所涉及的信息的收集和使用。 您可以在手机设置—隐私”中逐项查看您上述权限的开启状态，并可以决定将这些权限随时的开启或关闭（我们会指引您在您的设备系统中完成设置）。 ',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                  TextSpan(
                    text:
                        '请您注意，您开启这些权限即代表您授权Ms时代可以收集和使用这些个人信息来实现上述的功能，您关闭权限即代表您取消了这些授权，则我们将不再继续收集和使用您的这些个人信息，也无法为您提供上述与这些授权所对应的功能。您关闭权限的决定不会影响此前基于您的授权所进行的个人信息的处理。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '（三）您充分知晓，以下情形中，我们搜集、使用个人信息无需征得您的授权同意:',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '1）与国家安全、国防安全有关的；',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '2）与公共安全、公共卫生、重大公共利益有关的；',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '3）与犯罪侦查、起诉、审判和判决执行等司法或行政执法有关的；',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '4）出于维护您或其他个人的生命、财产等重大合法权益但又很难得到本人同意的；',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '5）您自行向社会公众公开的个人信息；',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '6）从合法公开披露的信息中收集个人信息的，如合法的新闻报道、政府信息公开等渠道。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '7）根据与您签订和履行相关协议或其他书面文件所必需的；',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '8）用于维护所提供的产品及/或服务的安全稳定运行所必需的，例如发现、处置产品及/或服务的故障；',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '9）为合法的新闻报道所必需的；',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '10）学术研究机构基于公共利益开展统计或学术研究所必要，且对外提供学术研究或描述的结果时，对结果中所包含的个人信息进行去标识化处理的；',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '11）法律法规规定的其他情形。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '（四）若你提供的信息中含有其他用户的个人信息，在向Ms时代提供这些个人信息之前，您需确保您已经取得合法的授权。若我们将信息用于本隐私条款未载明的其他用途，或者将基于特定目的收集而来的信息用于其他目的，或者我们主动从第三方处获取您的个人信息，均会事先获得您的同意。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '（五）如我们停止运营Ms时代平台上的产品或服务，我们将及时停止继续收集您个人信息的活动，将停止运营的通知以逐一送达或公告的形式通知您，并对我们所持有的与已关停业务相关的个人信息进行删除或匿名化处理。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '二、我们如何使用 Cookie ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '我们使用cookie来储存用户的喜好和记录活动信息以确保用户不会重复收到同样的广告和定制的时事通讯、广告以及基于浏览器类型和用户档案信息的网页内容。 我们不会把在cookie中保存的信息与您在我们网站上提交的任何个人识别信息相连接。您可以通过设置您的浏览器以接受或者拒绝全部或部分的cookie，或要求在cookie被设置时通知您。由于每个浏览器是不同的，请查看浏览器的“帮助”菜单来了解如何更改您的cookie选择参数。但如果您这么做，则需要在每一次访问我们的网站时更改 用户设置，而且您之前所记录的相应信息也均会被删除，并且可能会对您所使用服务的安全性有一定影响。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '四、我们如何共享、转让、公开披露您的信息',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '1. 共享',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '我们不会与Ms时代以外的公司、组织和个人共享您的个人信息，但以下情况除外：',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '1) 事先获得您的明确同意。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '2) 根据法律法规规定、诉讼、争议解决需要，或按行政、司法机关依法提出的要求。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '3) 我们可能会将您的个人信息与我们的关联方共享。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                  TextSpan(
                    text:
                        '但我们只会共享必要的个人信息，且受本隐私条款中所声明目的的约束。我们的关联方如要改变个人信息的处理目的，将再次征求您的授权同意。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '4) 我们可能委托授权合作伙伴为您提供某些服务或代表我们履行职能，我们仅会出于本隐私条款声明的合法、正当、必要、特定、明确的目的共享您的信息，授权合作伙伴只能接触到其履行职责所需信息，且不得将此信息用于其他任何目的。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '目前，我们的授权合作伙伴包括以下类型：',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        'A.广告、分析服务类的授权合作伙伴。除非得到您的许可，否则我们不会将您的个人身份信息与提供广告、分析服务的合作伙伴共享。我们会委托这些合作伙伴处理与广告覆盖面和有效性相关的信息，但不会提供您的个人身份信息，或者我们将这些信息进行去标识化处理，以便它不会识别您个人。这类合作伙伴可能将上述信息与他们合法获取的其他数据相结合，以执行我们委托的广告服务或决策建议。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        'B.供应商、服务提供商和其他合作伙伴。我们将信息发送给支持我们业务的供应商、服务提供商和其他合作伙伴，这些支持包括受我们委托提供的技术基础设施服务、分析我们服务的使用方式、衡量广告和服务的有效性、提供客户服务、支付便利或进行学术研究和调查。 我们会对授权合作伙伴获取有关信息的应用程序接口（API）、软件工具开发包（SDK）进行严格的安全检测，并与授权合作伙伴约定严格的数据保护措施，令其按',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '5) 我们的产品集成友盟+SDK，友盟+SDK需要收集您的设备Mac地址、唯一设备识别码（IMEI/android ID/IDFA/OPENUDID/GUID、SIM 卡 IMSI 信息）以提供统计分析服务，并通过地理位置校准报表数据准确性，提供基础反作弊服务。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '2. 转让',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '我们不会将您的个人信息转让给任何公司、组织和个人，但以下情况除外：',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '1) 事先获得您的明确同意。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '2) 根据法律法规规定、诉讼、争议解决需要，或按行政、司法机关依法提出的要求外部链接。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '3) 在涉及合并、收购、资产转让或类似的交易时，如涉及到个人信息转让，我们会要求新的持有您个人信息的公司、组织继续受本隐私条款的约束，否则，我们将要求该公司、组织重新向您征求授权同意。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '3. 公开披露',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '我们仅会在以下情况下，且采取符合业界标准的安全防护措施的前提下，才会公开披露您的个人信息:',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '1) 事先获得您的明确同意。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '2) 根据法律、法规的要求、强制性的行政执法或司法要求所必须提供您个人信息的情况下，我们可能会依据所要求的个人信息类型和披露方式公开披露您的个人信息。在符合法律法规的前提下，当我们收到上述披露信息的请求时，我们会要求必须出具与之相应的法律文件，如传票或调查函。我们坚信，对于要求我们提供的信息，应该在法律允许的范围内尽可能保持透明。我们对所有的请求都进行了慎重的审查，以确保其具备合法依据，且仅限于执法部门因特定调查目的且有合法权利获取的数据。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '五、我们如何保护您的信息',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '我们会采取合理措施保护存储在我们数据库中的用户个人信息，并且对那些需要履行其工作职责的雇员，比如我们的客户服务人员和技术人员， 获取用户个人信息进行限制。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '我们会采取一切合理可行的措施，确保未收集无关的个人信息。我们只会在达成本隐私条款所述目的所需的期限内保留您的个人信息，除非需要延长保留期或受到法律的允许。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                  TextSpan(
                    text: '在您的个人信息超出保留期间后，我们会根据适用法律的要求删除您的个人信息，或使其匿名化处理。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '如果我们终止服务或运营，我们会至少提前三十日向您通知，并在终止服务或运营后对您的个人 信息进行删除或匿名化处理。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '请注意，互联网并非绝对安全的环境，您在使用我们服务时自愿共享甚至公开分享的信息，可能会涉及您或他人的个人信息甚至个人敏感信息。请您更加谨慎地考虑，是否在使用我们的服务时共享甚至公开分享相关信息。请使用复杂密码，协助我们保证您的账号安全。我们将尽力保障您发送给我们的任何信息的安全性。如果我们的物理、技术或管理防护设施遭到破坏，导致信息被非授权访问、公开披露、篡改或毁坏，导致您的合法权益受损，我们将承担相应的法律责任。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '在不幸发生个人信息安全事件后，我们将按照法律法规的要求向您告知：安全事件的基本情况和可能的影响、我们已采取或将要采取的处置措施、您可自主防范和降低风险的建议、对您的补救措施等。事件相关情况我们将以邮件、信函、电话、推送通知等方式告知您，难以逐一告知个人信息主体时，我们会采取合理、有效的方式发布公告。 同时，我们还将按照监管部门要求，上报个人信息安全事件的处置情况。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '六、我们如何处理未成年人的信息',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '在电子商务活动中我们推定您具有相应的民事行为能力。如您为未成年人，我们要求您请您的父母或监护人仔细阅读本隐私条款，并在征得您的父母或监护人同意的前提下使用我们的服务或向我们提供信息。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '对于经父母或监护人同意使用我们的产品或服务而收集未成年人个人信息的情况，我们只会在法律法规允许、父母或监护人明确同意或者保护未成年人所必要的情况下使用、共享、转让或披露此信息。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '七、您的信息如何在全球范围转移',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '我们在中华人民共和国境内运营中收集和产生的个人信息，存储在中国境内，以下情形除外：',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '1、适用的法律有明确规定；',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '2、获得您的明确授权；',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '3、您通过互联网进行跨境交易等个人主动行为。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '针对以上情形，我们会确保依据本隐私条款对您的个人信息提供足够的保护。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '八、本隐私条款如何更新',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '我们可能对本隐私条款不时进行修改。如果我们进行任何修改，我们将在Ms时代平台主页上发布通知以使用户知道被修改内容的类型以及指示用户审阅更新的隐私条款。 如果您在对本隐私条款任何细微修改发布后继续使用网站，则表示您同意遵守任何该等修改。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '九、如何联系我们',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '本隐私条款与您所使用的Ms时代平台服务以及该服务所包括的各种业务功能（以下统称“我们的产品与/或服务”）息息相关， 希望您在使用我们的产品与/或服务前仔细阅读并确认您已经充分理解本条款所写明的内容，并让您可以按照本隐私条款的指引做出您认为适当的选择。 本隐私条款中涉及的相关术语，我们尽量以简明扼要的表述，并提供进一步说明的链接，以便您更好地理解。您使用或在我们更新本隐私条款后（我们会及时提示您更新的情况）继续使用我们的产品与/或服务， 即意味着您同意本隐私条款(含更新版本)内容，并且同意我们按照本隐私条款收集、使用、保存和共享您的相关信息。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '如果您就本隐私条款有任何疑问，请与我们客服联系客服热线：400-889-9966。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 2.0),
                  ),
                ]),
              ),
            ],
          ),
        ));
  }
}

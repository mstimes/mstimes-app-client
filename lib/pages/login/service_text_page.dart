import 'dart:ui';

import 'package:flutter/material.dart';

class ServiceTextPage extends StatelessWidget {
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
            '用户协议',
            style: TextStyle(
                fontSize: 30 * rpx,
                fontWeight: FontWeight.w400,
                color: Colors.black),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 25 * rpx, right: 25 * rpx),
          child: ListView(
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'Ms时代用户服务使用协议',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        height: 2.0)),
              ),
              RichText(
                text: TextSpan(
                    text: '',
                    style: TextStyle(color: Colors.black, fontSize: 13),
                    children: <InlineSpan>[
                      TextSpan(
                          text:
                              '          欢迎使用"Ms时代"服务，为了保障您的权益，请在使用“Ms时代”前，详细阅读此服务协议（以下简称"本协议"）的所有内容，特别是',
                          style: TextStyle(height: 2.0, fontSize: 13)),
                      TextSpan(
                        text:
                            '加粗部分。当您勾选"我已阅读并同意《Ms时代平台服务协议》"时，您的行为表示您已同意并签署了本协议。并同意遵守本协议中相关的规定。云水瀚沁（深圳）电子商务有限公司',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            height: 2.0),
                      ),
                      TextSpan(
                        text:
                            '（以下简称"公司"）是Ms时代App（以下简称"本软件"）的所有者和运营者，本协议构成您与公司达成的协议，具有法律效力。',
                        style: TextStyle(height: 2.0),
                      ),
                      TextSpan(
                        text:
                            '根据国家法律法规变化及本软件运营需要，Ms时代有权对本协议条款及相关规则不定时地进行修改，修改后的内容会提前7日在本软件上公示，修改后的协议将取代此前协议的相关内容，请您随时关注本软件公告、提示信息及协议、规则等相关内容的变动，知悉并确认。如您不同意更新后的内容，请立即停止使用本软件，如您继续使用本软件，公司即视为您已知悉并同意接受变动后的协议内容。',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            height: 2.0),
                      )
                    ]),
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: '一、服务需知',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 2.0),
                ),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '1、本软件运用自身开发的操作系统通过互联网络为用户提供购买商品等服务。使用本软件，您必须：',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                  TextSpan(
                    text:
                        '（1）自行配备上网的所需设备，包括个人手机、平板电脑、调制解调器、路由器等；（2）自行负担个人上网所支付的与此服务有关的电话费用、网络费用等；（3）选择与所安装终端设备相匹配的软件版本，包括但不限于iOS、Android、iPad等多个Ms时代发布的应用版本。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 13, height: 2.0),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '2、基于本软件所提供的网络服务的重要性，您确认并同意以下几点：',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                  TextSpan(
                    text:
                        '（1）提供的注册资料真实、准确、完整、合法有效，注册资料如有变动的，应及时更新；（2）如果您提供的注册资料不合法、不真实、不准确、不详尽的，您需承担因此引起的相应责任及后果，并且Ms时代保留终止您使用本软件各项服务的权利。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 13, height: 2.0),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '3、Ms时代是为用户提供获取商品和服务信息、就商品和服务的交易进行协商及开展交易的电子商务平台，平台上的所有商品和服务由云水瀚沁公司或入驻商家（以下统称为“销售商”）向用户提供，并承担其商品和服务（以下统称为“商品”）的质量保证责任。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: '二、定义',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 2.0),
                ),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '1、Ms时代是由公司所有和运营的分享类电商平台，用户登录Ms时代平台后，可以浏览平台上由各销售商发布的商品和服务信息，进行商品和/或服务交易等活动。在本协议项下，Ms时代服务的所有方、运营方会根据Ms时代业务调整的需要而变更，上述变更不会影响或削减您在本协议项下享有的权益。Ms时代服务的所有方、运营方还有可能因为提供新的服务而新增，如您使用新增的服务的，则视为您已经接受新增的Ms时代所有方与运营方。2、商家是指通过Ms时代平台陈列、销售商品或服务，并最终和用户完成交易的主体，是商品和服务的供应商和销售商。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 13, height: 2.0),
                  )
                ]),
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: '三、使用规则',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 2.0),
                ),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '1、您可浏览Ms时代陈列的商品或服务信息，如您希望选购并支付订单的，您需先登录或注册帐号，并根据页面提示提交选购的商品信息和个人信息，包括但不限于数量、规格、手机、姓名、身份证号码、送货地址等信息。如您提供的信息过期、无效进而导致销售商或Ms时代无法与您取得联系的，因此导致您在使用Ms时代服务中产生任何损失或增加费用的，应由您完全独自承担。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '2、您在注册时承诺遵守法律法规、社会主义制度、国家利益、公民合法权益、公共秩序、社会道德风尚和信息真实性等7条底线，不得在注册资料中出现违法和不良信息，且您保证在注册和使用帐号时，不得有以下情形： （a）违反宪法或法律法规规定的；  （b）危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的； （c）损害国家荣誉和利益的，损害公共利益的； （d）煽动民族仇恨、民族歧视，破坏民族团结的；  （e）破坏国家宗教政策，宣扬邪教和封建迷信的； （f）散布谣言，扰乱社会秩序，破坏社会稳定的； （g）散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的；  （h）侮辱或者诽谤他人，侵害他人合法权益的； （i）含有法律、行政法规、Ms时代平台禁止的其他内容的。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 13, height: 2.0),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '若您提供给Ms时代的帐号注册资料不准确，不真实，含有违法或不良信息的，Ms时代有权不予注册，并保留终止您使用Ms时代各项服务的权利。若您以虚假信息骗取帐号注册或帐号头像、个人简介等注册资料存在违法和不良信息的，Ms时代有权采取通知限期改正、暂停使用、注销登记等措施。对于冒用关联机构或社会名人注册帐号名称的，Ms时代有权注销该帐号，并向政府主管部门进行报告。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '3、您确认：在使用Ms时代说服务过程中，您应当是具备完全民事权利能力和完全民事行为能力的自然人、法人或其他组织。若您不具备前述主体资格，则您及您的监护人应承担因此而导致的一切后果，Ms时代有权向您的监护人追偿',
                    style: TextStyle(
                        color: Colors.black, fontSize: 13, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '4、您同意并保证：Ms时代有权记录您在选购商品或服务时，在线填写的所有信息并提供给销售商、第三方服务提供者（包括但不限于物流公司）或Ms时代的关联公司。您保证该等信息准确、合法，您承担因该等信息错误、非法等导致的后果。您授权Ms时代在本服务期间有权使用上述信息及向有关第三方提供该信息。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 13, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '5、Ms时代平台上的商品和服务的价格、数量等信息随时可能发生变动，对此Ms时代平台不作特别通知。由于Ms时代平台上的商品的数量庞大、互联网技术因素等客观原因存在，Ms时代平台上显示的信息可能存在一定的滞后和误差，对此请您知悉并理解。为最大限度的提高平台上商品信息的准确性、及时性、完整性和有效性，Ms时代平台有权对商品信息进行及时的监测、修改或删除。如您提交订单后，Ms时代平台发现平台的相关页面上包括但不限于商品名称、价格或数量价格等关键信息存在标注错误的，有权取消错误订单并及时通知销售商和您。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 13, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '6、您理解并同意：Ms时代实行先付款后发货的方式，您及时、足额、合法的支付选购商品或服务所需的款项是销售商给您发货的前提。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 13, height: 2.0),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '7、您支付交易款项过程中，将被邀请复查选购商品或服务的信息，包括单价、购买数量，付款方式，商品的运输方式和费用等。前述存储于Ms时代服务器的订单信息被认为是您的该次交易对应的发货、退货和争议事项的证据。',
                    style: TextStyle(
                        color: Colors.black, fontSize: 13, height: 2.0),
                  ),
                  TextSpan(
                    text:
                        '您点击“提交订单”意味着您认可订单表格中包含的所有信息都是正确和完整的。由于众所周知的互联网技术因素等客观原因存在，Ms时代显示的信息可能会有一定的滞后性或差错，对此情形您知悉并理解。由于排版错误或信息错误的情况下以不正确的价格列出来的商品，Ms时代有拒绝或取消任何对以不正确的价格列出来的商品所下订单的权利。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '8、您理解并同意：本软件上销售商展示的商品和价格等信息仅仅是要约邀请，您下单时须填写您希望购买的商品数量、价款及支付方式、收货人、联系方式、收货地址（合同履行地点）、合同履行方式等内容；系统生成的订单信息是计算机信息系统根据您填写的内容自动生成的数据，仅是您向销售商发出的合同要约；销售商收到您的订单信息后，只有在销售商将您在订单中订购的商品从仓库实际直接向您发出时（以商品出库为标志），方视为您与销售商之间就实际直接向您发出的商品建立了合同关系；如果您在一份订单里订购了多种商品并且销售商只给您发出了部分商品时，您与销售商之间仅就实际直接向您发出的商品建立了合同关系；只有在销售商实际直接向您发出了订单中订购的其他商品时，您和销售商之间就订单中其他已实际直接向您发出的商品才成立合同关系。对于电子书、数字音乐、在线手机充值等数字化商品，您下单并支付货款后合同即成立。在您与销售商的买卖合同成立之前，您与销售商均有权取消相关商品的订单，订单取消后，您已支付的款项将退回您的付款账户。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '9、您所选购的商品将被送至订单表格上注明的送货地址，具体物流服务由您所选购的商品的销售商提供。无论何种原因该商品不能送达到送货地址，请您尽快跟Ms时代客服热线取得联系，Ms时代平台将通知销售商进行解决。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '10、您可以随时使用自己的帐号和登录密码登录Ms时代平台，查询订单状态。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '11、在Ms时代平台上列出的所有送货时间仅为参考时间，如因以下情况造成订单延迟或无法配送、交货等，销售商不承担延迟配送、交货的责任，并有权在必要时取消订单：（1）用户提供的信息错误、地址不详细等原因导致的；（2）货物送达后无人签收，导致无法配送或延迟配送的；（3）情势变更因素导致的；（4）因节假日、大型促销活动、预购或抢购人数众多等原因导致的；（5）不可抗力因素导致的，例如：自然灾害、交通戒严、突发战争等。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '12、您有权在Ms时代平台上发布内容，同时也有义务独立承担您在Ms时代平台所发布内容的责任。用户发布的内容必须遵守法律法规及Ms时代平台的相关规定。您承诺不得发布以下内容，否则一经发现Ms时代平台有义务立即停止传输，保存有关记录，向国家有关机关报告，删除该内容或停止您的帐号的使用权限，并保留对您追究法律责任的权利。（1）侵犯他人知识产权或其他合法权利的相关内容；（2）透露他人隐私信息，包括但不限于真实姓名、联系方式、家庭住址、照片、站内短信、聊天记录、社交网络帐号等；（3）发布商业广告或在评论区域发布广告链接；（4）相关法律、行政法规、Ms时代平台禁止的其他内容。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '13、Ms时代平台进行优惠、促销的目的是为满足广大用户的消费需求，一切以牟利、排挤竞争为意图或者为达到其它恶意目的的参与行为均不予接受。若您存在以下不正当行为，一经发现Ms时代平台有权会同销售商采取包括但不限于暂停发货、取消订单、拦截已发货的订单、限制账户权限等措施：（1）将自有账户内的优惠、促销信息转卖、转让予他人；（2）通过Ms时代平台及其合作商的合法活动页面之外的第三方交易渠道获得优惠券并在Ms时代平台进行使用；（3）在Ms时代平台通过不正当手段恶意批量刷取优惠券并在Ms时代平台进行使用；（4）利用软件、技术手段或其他方式在Ms时代平台套取商品、优惠券、运费或者其他利益；（5）Ms时代平台认定的或国家法律法规规定的其他不正当行为。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '14、您理解并保证，您在使用Ms时代服务的过程中遵守诚实信用原则，不扰乱Ms时代的正常交易秩序，如果Ms时代根据您的登录帐号下的交易记录及其他相关信息，发现您有以下任一情形的：（1）您此前通过Ms时代购买的商品多数并非用于个人消费或使用用途的；（2）您此前存在多次（2次及以上）恶意购物行为的，即从事了相关购物行为，但积极主动终止购物目的或结果，或追求一般购物以外的目的或结果，对他人或Ms时代（可能）造成消极影响的行为。（3）Ms时代有合理理由怀疑您存在违反诚实信用原则的其他行为。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        'Ms时代有权自行或根据销售商的要求拒绝您的购买需求，若您已下达订单的，Ms时代有权单方面取消订单并通知销售商不予发货；同时，Ms时代有权视情况冻结您的登录帐号，使之无法通过Ms时代下达订单、购买商品。',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      height: 2.0,
                    ),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '15、您可将您与销售商关于交易的争议提交Ms时代，您同意委托Ms时代单方判断与该争议相关的事实及应适用的规则，进而作出处理决定，该判断和决定将对您具有法律约束力。但您理解并同意，Ms时代并非司法机构，仅能以普通人的身份对证据进行鉴别，Ms时代对争议的处理完全是基于您的委托，Ms时代无法保证争议处理结果符合您的期望，也不对争议处理结论承担任何责任。如您因此遭受损失，您同意自行向责任方追偿。',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      height: 2.0,
                    ),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '16、为使您能够及时、全面了解Ms时代提供的各类商品、服务及活动，您了解并同意，在征得您的同意的前提下，Ms时代可以通过您在注册、使用Ms时代过程中提供的联系方式多次、长期向您发送各类商业性短信息。',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      height: 2.0,
                    ),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '17、您同意在签收商品时进行当场验收，确认商品外包装完好无损后方进行签收。若您在验收过程中发现商品存在外包装破损，您有权拒绝签收并应及时联系客服进行反馈处理；若您未对商品进行前述验收即签收的，即视为商品验收合格。若订单信息中的收货人委托他人进行商品代收，代收人的签收行为视同订单信息中的收货人本人已对商品进行签收。若商品签收后发生的毁损、遗失等情况，销售商及Ms时代平台不承担任何责任。',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      height: 2.0,
                    ),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '18、您知悉并同意，Ms时代平台将按照《隐私政策》的约定收集、使用并保护您的相关信息。',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      height: 2.0,
                    ),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '19、您知悉并同意，为更好地为您提供服务，Ms时代平台会引入第三方为您提供服务，如您接受该第三方提供的服务的，您将与该第三方就服务事项签署相关协议。',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      height: 2.0,
                    ),
                  )
                ]),
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: '四、其他约定',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 2.0),
                ),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '1、您如对本协议项下Ms时代服务有任何疑问，请登录获取相关信息或拨打客服电话。',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      height: 2.0,
                    ),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '2、责任范围和限制（1）您了解Ms时代仅提供这一平台作为您获取商品或服务信息、物色交易对象、就商品和/或服务的交易进行协商及开展交易的非物理场所，但Ms时代无法控制交易所涉及的物品的质量、安全或合法性，商贸信息的真实性或准确性，以及交易各方履行其在贸易协议中各项义务的能力。您应自行谨慎判断确定相关商品及/或信息的真实性、合法性和有效性，并自行承担因此产生的责任与损失。（2）对发生下列情形之一所造成的不便或损害，Ms时代免责：a 定期检查或施工，更新软硬件而造成的服务中断，或突发性的软硬件设备与电子通信设备故障；b 网络服务提供商线路或其他故障，黑客攻击、病毒入侵等，服务器遭受损害，无法正常运作；c 在紧急情况之下依照法律的规定而采取的措施；d 因您提供的身份信息不完整或不准确而导致的海关通关失败；e 您购买的商品因违反有关法律法规的规定而被海关扣留；f 您与其它任何第三方的纠纷。（3）无论何种原因Ms时代对您的购买行为的赔偿金额将不会超过您受到影响的当次购买行为已经实际支付的费用的总额。',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      height: 2.0,
                    ),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '3、所有权及知识产权：1）Ms时代上所有内容，包括但不限于文字、软件、声音、图片、录像、图表、网站架构、网站画面的安排、网页设计、在广告中的全部内容、商品以及其它信息均由Ms时代或其他权利人依法拥有其知识产权，包括但不限于商标权、专利权、著作权、商业秘密等。非经Ms时代或其他权利人书面同意，您不得擅自使用、修改、全部或部分复制、公开传播、改变、散布、发行或公开发表、转载、引用、链接、抓取或以其他方式使用本平台程序或内容。如有违反，您同意承担由此给Ms时代或其他权利人造成的一切损失。2）Ms时代平台尊重知识产权并注重保护用户享有的各项权利。在Ms时代平台上，用户可能需要通过发表评论等各种方式向Ms时代平台提供内容。在此情况下，用户仍然享有此等内容的完整知识产权，但承诺不将已发表于本平台的信息，以任何形式发布或授权其他主体以任何方式使用。用户在提供内容时将授予Ms时代平台一项全球性的免费许可，允许Ms时代平台及其关联公司使用、传播、复制、修改、再许可、翻译、创建衍生作品、出版、表演及展示此等内容。3）Ms时代不保证平台上由其他权利人提供的所有内容没有侵犯任何第三方的合法权益，如您认为前述内容侵犯您的合法权益，请及时与Ms时代联系，Ms时代将在法律规定范围内协助您解决问题。',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      height: 2.0,
                    ),
                  ),
                  TextSpan(
                    text:
                        '4、通知：所有发给您的通知都可通过短信息、常规的信件或在网站显著位置公告的方式进行传送。5、您了解并同意，Ms时代根据自身的判断，认为您的行为涉嫌违反本协议的条款，则Ms时代有权暂停或停止向您提供服务，且无须为此向您或任何第三方承担责任。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        '6.本协议适用中华人民共和国的法律。当本协议的任何内容与中华人民共和国法律相抵触时，应当以法律规定为准，同时相关条款将按法律规定进行修改或重新解释，而本协议其他部分的法律效力不变。',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      height: 2.0,
                    ),
                  ),
                  TextSpan(
                    text:
                        '7、如用户在使用Ms时代服务过程中出现纠纷，应进行友好协商，若协商不成，应将纠纷提交公司所在地人民法院提起诉讼。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '8、本协议自发布之日起实施，并构成您和公司之间的协议。本协议的最终解释权归属于公司。',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      height: 2.0,
                    ),
                  )
                ]),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: '使用条款',
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
                        '请务必认真阅读和理解本《Ms时代内容上传协议》（以下简称“协议”） 中规定的所有权利和限制。您（“用户”）一旦注册、登录、使用等行为将视为对本《协议》的接受，即表示您同意接受本《协议》各项条款的约束。如果您不同意本《协议》中的条款，您可以放弃注册、登录或使用本协议所涉及的相关服务。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '本《协议》是用户与云水瀚沁（深圳）电子商务有限公司（下称“Ms时代”）之间的法律协议。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '一、定义',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '1、“Ms时代”是指云水瀚沁（深圳）电子商务有限公司（以下简称"云水瀚沁"）旗下所属的互联网网站平台、社交电商平台。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '2、“用户”是指愿意接受本协议，注册成为Ms时代用户并使用云水瀚沁提供的网络服务的个人、单位或任何组织。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '3、“二次创作”是指用户使用了已存在的文字、图像、影片、 音乐或其他作品进行的创作。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '4、“网络收集”是指用户自行从互联网上收集的、非为用户创作的内容。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '5、“无授权转载”是指未经著作权人授权，擅自将他人作品发布到Ms时代的行为。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '6、“Ms时代合作推广专区”系指云水瀚沁公司以宣传推广用户上传之内容为目的，与第三方合作设立的推广专区，通过包括但不限于网页调用等方式调用Ms时代软件中的内容向第三方用户提供阅读和浏览服务，Ms时代合作推广专区属于Ms时代软件的一部分。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '二、内容上传',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '1、Ms时代依法禁止用户向Ms时代上传、发布、传播含有下列内容之一的作品：',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: 'a 、反对宪法所确定的基本原则的；',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: 'b 、危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: 'c 、损害国家荣誉和利益的；',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: 'd 、煽动民族仇恨、民族歧视，破坏民族团结的；',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: 'e 、破坏国家宗教政策，宣扬邪教和封建迷信的；',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: 'f 、散布谣言，扰乱社会秩序，破坏社会稳定的；',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: 'g 、散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的；',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: 'h 、侮辱或者诽谤他人，侵害他人合法权益的；',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: 'i 、含有法律、行政法规禁止的其他内容的。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '2、上传内容要求：',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '在Ms时代中，用户所上传、发布、传播的内容应遵守以下规定',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: 'a 、用户于Ms时代所上传的一切内容，均应为漫画作品或与漫画作品相关的图片作品；',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        'b 、上传内容中凡选择标注为“完全原创”的，用户应保证该内容完全为用户本人独立创作，拥有完整、合法的权利在Ms时代上传、发布、传播，不得侵犯其他任何第三方的著作权、商标权、名誉权或其他任何合法权益；',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        'c 、上传内容中凡选择标注为“二次创作”的，用户应当保证其改编原作品并在Ms时代上传二次创作之作品的行为已经获得了原作品著作权人的授权；同时，用户应当标注原作品的名称和原作者的署名，并拥有完整、合法的权利在Ms时代上传、发布、传播，不得侵犯其他任何第三方的著作权、商标权、名誉权或其他任何合法权益。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        'd 、上传内容中凡标注为“网络收集”的，用户应当保证已经获得相关著作权人的授权拥有在互联网上发布该等内容的相关权利，或原作者明确声明允许自由转载（此种情况应附相关声明原文）；同时，用户应当标注原作者的署名，并应当同时标注该等内容的出处；',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        'e 、用户上传无权发布、传播或侵犯其他任何第三方的著作权、商标权、名誉权或其他任何合法权益的作品的，将被视为Ms时代禁止的无授权转载行为。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: 'f 、未经Ms时代书面同意，用户不得以任何形式在Ms时代发布任何广告消息。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '3、用户同意Ms时代作为信息存储空间及网络服务提供者，可以向其他平台推荐、转载用户主动上传、发布、传播到Ms时代的内容。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '4、未经Ms时代事先书面同意，用户不得擅自使用、复制或授权他人使用Ms时代的商标、标志及其他任何显著性标识。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '三、对于无授权转载的处理',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '1、Ms时代作为信息存储空间、及网络服务提供者，对用户的无授权转载行为的发生不具备充分的监控能力。如权利人认为用户上传的内容侵犯其著作权或其他任何权利，并向Ms时代提交书面通知，要求Ms时代断开、删除该上传内容的，Ms时代有权删除该上传内容并将该通知及权利人附交的证据转发给用户。如用户注册时填写的联系方式不明或因其他原因无法转交的，Ms时代有权将通知的内容在Ms时代上公告，视为送达。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '2、用户接到Ms时代转送的通知后，认为上传的内容未侵犯他人权利的，可以向Ms时代提交反通知，要求恢复被删除的上传内容。反通知应当包含下列内容：',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: 'a 、用户的真实姓名、联系方式和地址；',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: 'b 、要求恢复的上传内容的名称和网络地址/链接；',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: 'c 、不构成侵权的证明材料。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '3、Ms时代收到用户的反通知后，会立即删除Ms时代上的公告（如已发布）。Ms时代将恢复被删除或被断开链接的上传内容，同时将反通知转送权利人。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '4、用户违反本协议的，Ms时代有权要求用户对Ms时代因此所遭受到的损失进行赔偿（包括但不限于因此而产生的罚款、赔偿、补偿、违约金、律师费、公证费和诉讼费等费用）。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '四、免责声明',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '1、凡用户上传之内容，内容涉及之一切相关权利责任由用户自负，Ms时代仅提供信息存储空间并供用户展示之用。Ms时代有权对上传内容进行自动筛选，排版，推荐。Ms时代有权不事先通知用户即撤消或删除上传内容，并无需向用户承担任何责任',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '2、在适用法律允许的最大范围内，Ms时代明确表示不提供任何类型的保证，不论是明示的或默示的，包括但不限于适销性、适用性、可靠性、准确性、完整性、无病毒以及无错误的任何默示保证和责任。另外，在适用法律允许的最大范围内，Ms时代并不担保服务一定能满足用户的要求，也不担保服务不会被修改、中断或终止，并且对服务的及时性、安全性、错误发生，以及信息是否能准确、及时、顺利的传送均不作任何担保。作者自行留存原稿，Ms时代对因任何原因导致用户上传的内容灭失均不承担责任。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '3、在适用法律允许的最大范围内，Ms时代不就因用户使用服务引起的或与服务有关的任何意外的、非直接的、特殊的、或间接的损害或请求（包括但不限于因人身伤害、因隐私泄漏、因未能履行包括诚信或合理谨慎在内的任何责任、因过失和因任何其他金钱上的损失或其他损失而造成的损害赔偿）承担任何责任。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '4、Ms时代有权利为宣传Ms时代之目的使用用户上传、发布、传播的内容（包括但不限于在广告、推荐位、Ms时代合作推广专区中推广），并无需向用户支付任何费用或承担任何责任，但不得以收费方式向公众提供该内容的在线阅读和浏览服务。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '5、Ms时代在宣传推广用户上传、发布、传播的内容（包括但不限于在广告、推荐位、Ms时代合作推广专区中推广）时，有权同时标注Ms时代的标识（包括但不限于相关的文字表述、Ms时代的名称、LOGO等）。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '五、Ms时代的承诺',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        'Ms时代承诺将善意地向第三方宣传和推广用户上传、发布、传播的内容，在未经通知并与用户达成一致前，不会以收费方式向公众提供该内容的线下和/或在线的阅读和浏览服务，或通过向第三方合作收费的形式向其提供用户上传、发布、传播的内容。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '六、争议解决与适用法律',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '1、本协议的订立、执行和解释及争议的解决均应适用中华人民共和国法律。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '2、如用户与Ms时代就本协议的内容或其履行发生任何争议，协商不成时，任何一方均可向北京市仲裁委员会申请仲裁，仲裁地点为北京，仲裁裁决是终局的，对双方均有约束力。仲裁期间，双方都将继续执行除仲裁部分以外的其他协议条款。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '七、其他',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '1、Ms时代未能及时行使本协议项下的权利不应被视为放弃该权利，也不影响在将来行使该权利。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '2、Ms时代有权随时根据有关法律、法规的变化以及公司经营状况和经营策略的调整等修改本协议。修改后的协议会在Ms时代网站上公布。当发生有关争议时，以最新的协议文本为准。如果不同意改动的内容，用户可以不选择使用Ms时代提供的服务。如果用户继续使用Ms时代提供的服务，则视为用户接受本协议的变动。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '3、Ms时代在法律允许的最大范围内对本协议拥有解释权与修改权。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text:
                        '4、如用户与云水瀚沁（深圳）电子商务有限公司签订了其他书面合同的，本协议作为该书面合同的一部分，与该书面合同具同等效力；该书面合同与本协议规定不一致的，适用书面合同的规定。',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
            ],
          ),
        ));
  }
}

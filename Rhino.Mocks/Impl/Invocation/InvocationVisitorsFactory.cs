using System.Collections.Generic;
using andri.Mocks.Impl.Invocation.Actions;
using andri.Mocks.Impl.Invocation.Specifications;
using andri.Mocks.Interfaces;

namespace andri.Mocks.Impl.Invocation
{
    ///<summary>
    ///</summary>
    public class InvocationVisitorsFactory
    {
        ///<summary>
        ///</summary>
        public IEnumerable<InvocationVisitor> CreateStandardInvocationVisitors(IMockedObject proxy_instance, MockRepository mockRepository)
        {
            List<InvocationVisitor> invocation_visitors = new List<InvocationVisitor>();
            invocation_visitors.Add(new InvocationVisitor(new IsAnInvocationOfAMethodBelongingToObject(),
                                                          new Proceed()));
            invocation_visitors.Add(new InvocationVisitor(new IsAnInvocationOnAMockedObject(),
                                                          new InvokeMethodAgainstMockedObject(proxy_instance)));
            invocation_visitors.Add(new InvocationVisitor(new IsInvocationThatShouldTargetOriginal(proxy_instance),
                                                          new Proceed()));

            invocation_visitors.Add(new InvocationVisitor(new IsAPropertyInvocation(proxy_instance),
                                                          new InvokeProperty(proxy_instance, mockRepository)));


            return invocation_visitors;
        }
    }
}